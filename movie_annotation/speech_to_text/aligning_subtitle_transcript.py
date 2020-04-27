import pysrt
import json
from nltk.corpus import stopwords
from itertools import *
from nltk.stem import PorterStemmer
from nltk.tokenize import word_tokenize
from dtw import accelerated_dtw
import numpy as np
from nltk.metrics.distance import edit_distance
from Levenshtein import *
import xlsxwriter

#movie_name = input("movie name:")
movie_name = 'citizenfour'
subtitle_document = "/Users/huangjiawen/EBDb_project/movie_annotation/movie_subtitles_and_transcripts/%s_subtitle.srt"%movie_name
transcript_document = "/Users/huangjiawen/EBDb_project/movie_annotation/movie_subtitles_and_transcripts/%s_transcript.json"%movie_name

subtitle = pysrt.open(subtitle_document)
with open(transcript_document,'r') as f:
    transcript = json.load(f)


def process_sentence(sentence):
    punctuations = ["#",".","!","?",'"',',','_',"'",";"]
    sentence_stemmed = []
    sentence = sentence.lower()  # make sentence lower case
    for p in punctuations:
        if p in sentence:
            sentence = sentence.replace(p,'')
    if '\n' in sentence:
        sentence = sentence.replace('\n',' ') # remove punctuations
    if '-' in sentence:
        sentence = sentence.replace('-',' ')

    sentence = sentence.split(' ')
    while '' in sentence:
        sentence.remove('')  # remove empty values from sentence word list
    for words in sentence:
        sentence_stemmed.append(ps.stem(words))  # create a stemmed list of words for dtw
    return sentence, sentence_stemmed


ps = PorterStemmer()


def guessing_words_fuc(list_of_words, start, end, container):
    dur_chunck = end-start
    sum_wordlen = sum(len(a) for a in list_of_words)
    for word in list_of_words:
        dur_word = dur_chunck*(len(word)/sum_wordlen)
        output_word = [word,start,start+dur_word]
        start = start+dur_word
        container.append(output_word)
# given the start time and end time of a list of words, estimate the st and et of each word based on letter length


def estimating_words(leftover, start, end, container_cont, container_est, within = True): # within: True if we're
    # estimating based on the start time
    if leftover !=[]:
        if start > end:
            if len(leftover) == 1:
                container_cont.append([leftover[0],start,end])
            else:
                guessing_words_fuc(leftover, start, end, container_est)
        elif start<end:  # if word has negative timing
            if within:   # most of the cases..
                if len(leftover) == 1:
                    container_cont.append([leftover[0], end-0.05*len(leftover[0]), end])
                else:
                    total_letters = ''
                    for word_l in leftover:
                        total_letters += word_l
                    guessing_words_fuc(leftover, end-0.05*len(total_letters), end, container_est)
            else:
        # another way we get negative timing is when the end time of the script is inaccurate and we used it to estimate
        # the last bits of subtitle line
                if len(leftover) == 1:
                    container_cont.append([leftover[0], start, end+0.05*len(leftover[0])])

                else:
                    total_letters = ''
                    for word_l in leftover:
                        total_letters += word_l
                    guessing_words_fuc(leftover, start, end+0.05*len(total_letters), container_est)



    return []


def duplicates(lst, item):
   return [i for i, x in enumerate(lst) if x == item]

# the format of the output of dtw is 2 arrays, that looks like:
#    [0,1,1,2,3,4,5,6,6,7] and [0,1,2,3,4,5,6,7,8,9], where word with index 0 (subtitle) is aligned with words with
# index 0 in the transcript, word with index 1 (subtitle) is aligned with words with index 1 and 2 in the transcript.
#  this function aims at reorganizing the two arrays into the format of a list. The index of the item in the list
# represents the index of subtitle words, and the value will be the transcript list it is aligned to.
# for the above example, the output will be [[0],[1,2],[3],[4],[5],[6],[7,8],[9]]


def reorganize_path(dtw_path):
    path_reorganized_1 = []
    if isinstance(dtw_path[0], np.ndarray):
        subtitle_path = dtw_path[0].tolist()
    else:
        subtitle_path = list(dtw_path[0])
    if isinstance(dtw_path[1],np.ndarray):
        transcript_path = dtw_path[1].tolist()
    else:
        transcript_path = list(dtw_path[1])
    for i in subtitle_path:
        if subtitle_path.count(i) == 1:
            transcript_path_to_add = [i,[transcript_path[subtitle_path.index(i)]]]
        else:
            transcript_path_to_add = [i,[transcript_path[i] for i in duplicates(subtitle_path,i)]]
        if transcript_path_to_add not in path_reorganized_1:
            path_reorganized_1.append(transcript_path_to_add)
    # below reorganize the path further to include situations where multiple sentence words aligned to
    # one transcript words
    trans_index = []
    for i in path_reorganized_1:
        trans_index.append(i[1][0])
    repeats = []
    for i in trans_index:
        if trans_index.count(i) != 1:
            repeats.append(i)
    repeats = list(set(repeats))
    dictionary_store = {}
    temp = []
    for r in repeats:
        for i in path_reorganized_1:
            if i[1][0] == r:
                temp.append(i[0])
                dictionary_store[str(r)] = temp
        temp = []
    final = []
    for item in path_reorganized_1:
        if str(item[1][0]) in list(dictionary_store.keys()):
            tba = [dictionary_store[str(item[1][0])], [int(item[1][0])]]
            if tba not in final:
                final.append(tba)
        else:
            final.append([[item[0]], item[1]])
    return final


subtitle_ls = []
subtitle_ls_stemmed = []
# organize subtitle document
for screen in subtitle:
    # correct the format of timing for subtitle from hour,minute,second,millisecond to seconds.milliseconds
    start_time = screen.start.hours * 3600 + screen.start.minutes * 60 + screen.start.seconds + screen.start.milliseconds/1000
    end_time = screen.end.hours * 3600 + screen.end.minutes * 60 + screen.end.seconds + screen.end.milliseconds/1000
    not_stemmed, stemmed = process_sentence(screen.text)
    subtitle_line = {"start_time": start_time,"end_time": end_time,"sentence_words": not_stemmed,
                     "sentence_words_stemmed": stemmed}
    subtitle_ls.append(subtitle_line)


#print(subtitle_ls)

# organize transcript document
transcript_ls = []
for transcript_items in transcript['results']['items']:
        if transcript_items['type'] == 'pronunciation':
            start_time = transcript_items["start_time"]
            end_time = transcript_items["end_time"]
            word = transcript_items["alternatives"][0]["content"]
            #  confidence = transcript_items["alternatives"][0]["confidence"]
            #  maybe something to be used for improving accuracy
            word = word.replace("'","")
            transcript_ls.append({"start_time": float(start_time), "end_time": float(end_time), "word": word.lower(),
                                  "word_stemmed": ps.stem(word.lower())})

estimated_words = []  # words estimated from just subtitle start&end time, and letter length
perfect_words = []  # perfectly matched words (where timing and word are the same in aws and subtitle)
estimated_words_with_aws = []  # words
estimated_words_continuous_speech = []
estimated_words_similar_match = []
count_instance_repeats = 0
perf2 = 0
output_table = []
output_table_as_ls = []

for sw in subtitle_ls:
    # get amazon words with timings starting 0.5 sec before the start time of the sentence and ends 0.5 sec
    # after the sentence
    #print(sw['sentence_words_stemmed'])
    aw_within = []
    aw_within_stemmed_words = []
    for aw in transcript_ls:
        if aw['start_time'] > sw['start_time']-0.5 and aw['end_time'] < sw['end_time']+0.5:
            aw_within.append(aw)
            aw_within_stemmed_words.append(aw['word_stemmed'])
    #print(aw_within_pure)
    # cannot do dtw if amazon don't have any words, will have to estimate based on subtitle duration and letter length
    # maybe worth removing lyrics from the subtitle or do it separately because for lyrics it seems occasions where
    # amazon didn't get anything is quite common.
    if aw_within == []:
        guessing_words_fuc(sw['sentence_words'], sw['start_time'], sw['end_time'], estimated_words)

    else:
        # dtw
        # acm = accumulated cost matrix, use path here
        distance,cost,acm,path = accelerated_dtw(np.array(sw['sentence_words_stemmed']), np.array(aw_within_stemmed_words),
                                                 edit_distance, warp=1)
        #print(path)

        # at the moment it's not good at dealing with situations where one amazon word is aligned with multiple
        # subtitle words (i.e. amazon get fewer words than the subtitle), so e.g. if "this, this" in subtitle is
        # aligned with the same "this" in the transcript, the second wouldn't get a timing because it would be repeated
        # can count how many instances like these there are first ...
        path_reo = reorganize_path(path)
        leftovers = []
        for i in range(0,len(path_reo)):
           # container of words that don't have a time tag
            amazon_word_indexes = path_reo[i][1]
            sentence_word_indexes = path_reo[i][0]
            #print(aw_stemmed_words_aligned)
            levenshtein_similarity = [jaro(sw['sentence_words'][int(k)], aw_within[int(j)]['word'])
                                      for j in amazon_word_indexes for k in sentence_word_indexes]
            # take a record of similarity between
            if len(sentence_word_indexes) == 1:     # if one subtitle word is matched with one/more transcript word
                sw_index = int(sentence_word_indexes[0])
                #print(sw_index)
                matched = False
                for aw_index in amazon_word_indexes:
                    if aw_within[aw_index]['word_stemmed'] == sw['sentence_words_stemmed'][sw_index]:
                        to_be_added = [sw['sentence_words'][sw_index], aw_within[aw_index]['start_time'],
                                       aw_within[aw_index]['end_time']]
                        if to_be_added not in perfect_words:
                            matched = True
                            leftovers = estimating_words(leftovers, sw['start_time'], aw_within[aw_index]['start_time'],
                                                         estimated_words_continuous_speech, estimated_words_with_aws)
                            # when finding a word that have an "accurate" timing, see if any words
                            # before the current word is not aligned, and if there are, estimate their timing and
                            # clear the "leftovers" container
                            sw['start_time'] = aw_within[aw_index]['end_time']
                            # change the start time of the sentence to the end time of accurate words, for the
                            # estimation of future left-overs
                            perfect_words.append(to_be_added)
                            # transcript_ls.remove(aw_within[aw_index])
                            output_table_as_ls.append([sw['sentence_words'][sw_index],aw_within[aw_index]["word"],aw_within[aw_index]['start_time'],aw_within[aw_index]['end_time'], aw_within[aw_index]['end_time']-aw_within[aw_index]['start_time'], 'perfect'])
                            break

                        # stops once the first match identified to avoid including other timings for the same word.
                        # (Potentially problematic, bc the timing of transcript word
                        #  that happen later could be the right timing instead)
                        # stop the [sw,aw] pair if there's perfect match

                    # remove words that are perfectly aligned with the subtitle word so it doesn't go into another
                    # subtitle line
                        # if it is not the same, take a record of the similarity between the sentence word and
                        # transcript word, if the highest similarity between a subtitle word and the amazon word
                        # it's aligned to is above a threshold use the timing of the amazon word
                if not matched and max(levenshtein_similarity) > 0.6:
                            # if the max similarity between the word in the subtitle is not
                    aw_index = int(amazon_word_indexes[levenshtein_similarity.index(max(levenshtein_similarity))])
                    to_be_added = [sw['sentence_words'][sw_index], aw_within[aw_index]['start_time'],
                                           aw_within[aw_index]['end_time']]
                    if to_be_added not in estimated_words_similar_match:
                        matched = True
                        leftovers = estimating_words(leftovers, sw['start_time'], aw_within[aw_index]['start_time'],
                                                     estimated_words_continuous_speech, estimated_words_with_aws)
                        sw['start_time'] = aw_within[aw_index]['end_time']
                        estimated_words_similar_match.append(to_be_added)
                        output_table_as_ls.append([sw['sentence_words'][sw_index],aw_within[aw_index]["word"],aw_within[aw_index]['start_time'],  aw_within[aw_index]['end_time'], aw_within[aw_index]['end_time'] - aw_within[aw_index]['start_time'],'similar'])

                # if subtitle word not matched with anything, make record of it.
                elif not matched:
                    leftovers.append(sw['sentence_words'][sw_index])

            # if multiple subtitle words are aligned to one transcript word, estimate the timing based on the match:
            # if one & only one word is matched perfectly with the transcript word, take its timing and estimate the rest
            # if no perfect match but have "similar" match, use the timing of the most similar and estimate the rest
            # if none of the above, estimate all
            # how can i simplify it?

            else:
                aw_index = amazon_word_indexes[0]# a counter of no. of perfectly matched word
                perfect_w = [sw['sentence_words_stemmed'][j] for j in sentence_word_indexes
                             if aw_within[aw_index]['word_stemmed'] == sw['sentence_words_stemmed'][j]]

                # if more than one perfect matches/no perfect match and max similarity <.6, estimate all
                if len(perfect_w) > 1 or (len(perfect_w) == 0 and max(levenshtein_similarity)<.6):
                    for sw_index in sentence_word_indexes:
                        leftovers.append(sw['sentence_words'][sw_index])

                # if only one perfect match use its timing and estimate others
                elif len(perfect_w) == 1:
                    for sw_index in sentence_word_indexes:
                        if sw['sentence_words_stemmed'][sw_index] in perfect_w:
                            to_be_added = [sw['sentence_words'][sw_index], aw_within[aw_index]['start_time'],
                                           aw_within[aw_index]['end_time']]
                            if to_be_added not in perfect_words:
                                leftovers = estimating_words(leftovers, sw['start_time'], aw_within[aw_index]['start_time'],
                                                             estimated_words_continuous_speech, estimated_words_with_aws)
                                sw['start_time'] = aw_within[aw_index]['end_time']

                                perfect_words.append(to_be_added)
                                output_table_as_ls.append([sw['sentence_words'][sw_index], aw_within[aw_index]["word"],aw_within[aw_index]['start_time'],aw_within[aw_index]['end_time'],aw_within[aw_index]['end_time'] - aw_within[aw_index]['start_time'], 'perfect'])

                        else:
                            leftovers.append(sw['sentence_words'][sw_index])

                # if no perfect match but max similarity > .6 gives the timing to the subtitle word with
                # highest similarity and estimate the rest

                elif len(perfect_w) == 0:
                    most_similar_index = sentence_word_indexes[levenshtein_similarity.index(max(levenshtein_similarity))]
                    for sw_index in sentence_word_indexes:
                        if sw_index == most_similar_index:
                            to_be_added = [sw['sentence_words'][sw_index], aw_within[aw_index]['start_time'],
                                           aw_within[aw_index]['end_time']]
                            if to_be_added not in estimated_words_similar_match:
                                leftovers = estimating_words(leftovers, sw['start_time'], aw_within[aw_index]['start_time'],
                                                 estimated_words_continuous_speech, estimated_words_with_aws)
                                sw['start_time'] = aw_within[aw_index]['end_time']
                                estimated_words_similar_match.append(to_be_added)
                                output_table_as_ls.append([sw['sentence_words'][sw_index],aw_within[aw_index]["word"], aw_within[aw_index]['start_time'],  aw_within[aw_index]['end_time'], aw_within[aw_index]['end_time'] - aw_within[aw_index]['start_time'],'similar'])

                        else:
                            leftovers.append(sw['sentence_words'][sw_index])

            if i == len(path_reo)-1 and len(leftovers) != []:
                # at the end of a subtitle line, check if any words still left not estimated, if so estimate based on
                # start_time (= end time of the previously aligned word), and end time of sentence.
                leftovers = estimating_words(leftovers, sw['start_time'], sw['end_time'],
                                 estimated_words_continuous_speech, estimated_words_with_aws)




    # for transcript words that are matched, remove them from list, so they don't get duplicated in the next line if
    # the beginning of the next sentence contain the same words as the end of the previous sentence.


    # if the sentence word is aligned with 1/more transcript words, use the start of the first words it is aligned to and end ti


for words in estimated_words:
    output_table_as_ls.append([words[0], '', words[1], words[2],float(words[2]-words[1]),'complete_est'])
for words in estimated_words_continuous_speech:
    output_table_as_ls.append([words[0], '', words[1], words[2],float(words[2]-words[1]),'continuous'])
for words in estimated_words_with_aws:
    output_table_as_ls.append([words[0], '', words[1], words[2],float(words[2]-words[1]),'part_est'])

#  order words in the occurrence
def ordering_words(word_list):
    ls_of_st = []
    output_ls = []
    word_list_temp = [i for i in word_list]
    for l in word_list:
        ls_of_st.append(l[2])
    while len(output_ls) != len(word_list):
        min_index = ls_of_st.index(min(ls_of_st))
        output_ls.append(word_list_temp[min_index])
        word_list_temp.remove(word_list_temp[min_index])
        ls_of_st.remove(ls_of_st[min_index])
    return output_ls


output_table_as_ls = ordering_words(output_table_as_ls)



freq_perfect = 0
freq_similar = 0
freq_est_part = 0
freq_est_cont = 0
freq_est_all = 0
sum_duration_perfect = 0
sum_duration_continuous =0
sum_duration_similar =0
sum_duration_complete = 0
sum_duration_partial = 0

for ls in output_table_as_ls:
    if ls[5] == 'perfect':
        freq_perfect+=1
        sum_duration_perfect += ls[4]
    elif ls[5] =='continuous':
        freq_est_cont +=1
        sum_duration_continuous +=ls[4]
    elif ls[5] =='similar':
        freq_similar += 1
        sum_duration_similar+=ls[4]
    elif ls[5] == 'complete_est':
        freq_est_all +=1
        sum_duration_complete+=ls[4]
    elif ls[5] == 'part_est':
        freq_est_part+=1
        sum_duration_partial+=ls[4]

total = sum([freq_est_all, freq_est_cont, freq_est_part, freq_perfect,freq_similar])
workbook = xlsxwriter.Workbook('word_timing.xlsx')
worksheet1 = workbook.add_worksheet('timing')
worksheet2 = workbook.add_worksheet('descriptive_stats')
row=1
col=0
worksheet1.write(0,0,"subtitle")
worksheet1.write(0,1,"transcript")
worksheet1.write(0,2,"start_time")
worksheet1.write(0,3,"end_time")
worksheet1.write(0,4,"interval")
worksheet1.write(0,5,"type")
worksheet1.write(0,6,"start_time_new")
worksheet1.write(0,7,"end_time_new")
worksheet1.write(0,8,"interval_new")
for sub_word,trans_word,st,et,interval,typematch in output_table_as_ls:
    worksheet1.write(row, col, sub_word)
    worksheet1.write(row, col+1, trans_word)
    worksheet1.write(row, col+2, st)
    worksheet1.write(row, col+3, et)
    worksheet1.write(row, col+4, interval)
    worksheet1.write(row, col+5, typematch)
    worksheet1.write(row, col+6, st)
    if typematch=='complete_est' and interval > 1 and len(sub_word)<10:
        worksheet1.write(row,col+7, st+0.6)
        worksheet1.write(row, col + 8, 0.6)
    elif typematch=='complete_est' and interval > 2 and len(sub_word) > 10:
        worksheet1.write(row, col + 7, st+1)
        worksheet1.write(row, col + 8, 1)
    else:
        worksheet1.write(row, col + 7, st)
        worksheet1.write(row, col + 8, interval)

    row +=1



summary_stats= [['matches',freq_perfect,freq_perfect/total,sum_duration_perfect/freq_perfect],
               ['similarity',freq_similar, freq_similar/total,sum_duration_similar/freq_similar],
               ['complete',freq_est_all, freq_est_all/total, sum_duration_complete/freq_est_all],
                ['continuous',freq_est_cont,freq_est_cont/total,sum_duration_continuous/freq_est_cont],
                ['partial',freq_est_part,freq_est_part/total,sum_duration_partial/freq_est_part]]

row,column =1,0
worksheet2.write(0,0,"type")
worksheet2.write(0,1,"frequency")
worksheet2.write(0,2,"percentage")
worksheet2.write(0,3,"mean_duration")
for type,frequency,percentage,duration in summary_stats:
    worksheet2.write(row,column,type)
    worksheet2.write(row,column+1,frequency)
    worksheet2.write(row,column+2,percentage)
    worksheet2.write(row,column+3,duration)
    row = row+1
workbook.close()



