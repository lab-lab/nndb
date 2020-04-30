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
from nltk.corpus import stopwords
stopwords = set(stopwords.words('english'))

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


def guessing_words_fuc(list_of_words, start, end, container, adjusted=False):
    dur_chunck = end-start
    sum_wordlen = sum(len(a) for a in list_of_words)
    for word in list_of_words:
        dur_word = dur_chunck*(len(word)/sum_wordlen)
        if adjusted == True:
            output_word = [word,start,start+dur_word,'partial_adjusted']
        else:
            output_word = [word,start,start+dur_word,'partial']
        start = start+dur_word
        container.append(output_word)

# given the start time and end time of a list of words, estimate the st and et of each word based on letter length


def estimating_words(leftover, start, end, container_cont, container_est, container_adjusted, within=True):
    # within: True if we're estimating based on the start time i.e. a word is matched/similar
    if leftover !=[]:
        if start < end:
            if len(leftover) == 1:
                container_cont.append([leftover[0],start,end])
            else:
                guessing_words_fuc(leftover, start, end, container_est)
        elif start > end:  # if word has negative timing
            if within:   # most of the cases..
                if len(leftover) == 1:
                    container_adjusted.append([leftover[0], end-0.03*len(leftover[0]), end])
                else:
                    total_letters = ''
                    for word_l in leftover:
                        total_letters += word_l
                    guessing_words_fuc(leftover, end-0.03*len(total_letters), end, container_adjusted)
            else:
        # another way we get negative timing is when the end time of the script is inaccurate and we used it to estimate
        # the last bits of subtitle line
                if len(leftover) == 1:
                    container_cont.append([leftover[0], start, start+0.03*len(leftover[0])])

                else:
                    total_letters = ''
                    for word_l in leftover:
                        total_letters += word_l
                    guessing_words_fuc(leftover, start, start+0.03*len(total_letters), container_est)
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
matched_words = []  # perfectly matched words (where timing and word are the same in aws and subtitle)
estimated_words_with_aws = []  # words
estimated_words_continuous_speech = []
estimated_words_similar_match = []
estimated_words_adjusted = []
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
                        if to_be_added not in matched_words:
                            matched = True
                            leftovers = estimating_words(leftovers, sw['start_time'], aw_within[aw_index]['start_time'],
                                                         estimated_words_continuous_speech, estimated_words_with_aws,
                                                         estimated_words_adjusted)
                            # when finding a word that have an "accurate" timing, see if any words
                            # before the current word is not aligned, and if there are, estimate their timing and
                            # clear the "leftovers" container
                            sw['start_time'] = aw_within[aw_index]['end_time']
                            # change the start time of the sentence to the end time of accurate words, for the
                            # estimation of future left-overs
                            matched_words.append(to_be_added)
                            # transcript_ls.remove(aw_within[aw_index])
                            output_table_as_ls.append([sw['sentence_words'][sw_index],aw_within[aw_index]["word"],aw_within[aw_index]['start_time'],aw_within[aw_index]['end_time'], aw_within[aw_index]['end_time']-aw_within[aw_index]['start_time'], 'matched'])
                            break

                        # stops once the first match identified to avoid including other timings for the same word.
                        # (Potentially problematic, bc the timing of transcript word
                        #  that happen later could be the right timing instead)
                        # stop the [sw,aw] pair if there's perfect match

                        # if it is not the same, take a record of the similarity between the sentence word and
                        # transcript word, if the highest similarity between a subtitle word and the amazon word
                        # it's aligned to is above a threshold use the timing of the amazon word
                if not matched and max(levenshtein_similarity) > 0.6:
                            # if the max similarity between the word in the subtitle is not
                    aw_index = int(amazon_word_indexes[levenshtein_similarity.index(max(levenshtein_similarity))])
                    to_be_added = [sw['sentence_words'][sw_index], aw_within[aw_index]['start_time'],
                                           aw_within[aw_index]['end_time']]
                    if to_be_added not in (estimated_words_similar_match and matched_words):
                        matched = True
                        leftovers = estimating_words(leftovers, sw['start_time'], aw_within[aw_index]['start_time'],
                                                     estimated_words_continuous_speech, estimated_words_with_aws, estimated_words_adjusted)
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

            else:
                aw_index = amazon_word_indexes[0]
                # a counter of no. of perfectly matched word
                matched_w = [sw['sentence_words_stemmed'][j] for j in sentence_word_indexes
                             if aw_within[aw_index]['word_stemmed'] == sw['sentence_words_stemmed'][j]]

                # if more than one perfect matches/no perfect match and max similarity <.6, estimate all
                if len(matched_w) > 1 or (len(matched_w) == 0 and max(levenshtein_similarity)<.6):
                    for sw_index in sentence_word_indexes:
                        leftovers.append(sw['sentence_words'][sw_index])

                # if only one perfect match use its timing and estimate others
                elif len(matched_w) == 1:
                    for sw_index in sentence_word_indexes:
                        if sw['sentence_words_stemmed'][sw_index] in matched_w:
                            to_be_added = [sw['sentence_words'][sw_index], aw_within[aw_index]['start_time'],
                                           aw_within[aw_index]['end_time']]
                            if to_be_added not in matched_words:
                                leftovers = estimating_words(leftovers, sw['start_time'], aw_within[aw_index]['start_time'],
                                                             estimated_words_continuous_speech, estimated_words_with_aws,
                                                             estimated_words_adjusted)
                                sw['start_time'] = aw_within[aw_index]['end_time']

                                matched_words.append(to_be_added)
                                output_table_as_ls.append([sw['sentence_words'][sw_index], aw_within[aw_index]["word"],aw_within[aw_index]['start_time'],aw_within[aw_index]['end_time'],aw_within[aw_index]['end_time'] - aw_within[aw_index]['start_time'], 'matched'])

                        else:
                            leftovers.append(sw['sentence_words'][sw_index])

                # if no perfect match but max similarity > .6 gives the timing to the subtitle word with
                # highest similarity and estimate the rest

                elif len(matched_w) == 0:
                    most_similar_index = sentence_word_indexes[levenshtein_similarity.index(max(levenshtein_similarity))]
                    for sw_index in sentence_word_indexes:
                        if sw_index == most_similar_index:
                            to_be_added = [sw['sentence_words'][sw_index], aw_within[aw_index]['start_time'],
                                           aw_within[aw_index]['end_time']]
                            if to_be_added not in (estimated_words_similar_match and matched_words):
                                leftovers = estimating_words(leftovers, sw['start_time'], aw_within[aw_index]['start_time'],
                                                 estimated_words_continuous_speech, estimated_words_with_aws, estimated_words_adjusted)
                                sw['start_time'] = aw_within[aw_index]['end_time']
                                estimated_words_similar_match.append(to_be_added)
                                output_table_as_ls.append([sw['sentence_words'][sw_index],aw_within[aw_index]["word"], aw_within[aw_index]['start_time'],  aw_within[aw_index]['end_time'], aw_within[aw_index]['end_time'] - aw_within[aw_index]['start_time'],'similar'])

                        else:
                            leftovers.append(sw['sentence_words'][sw_index])

            if i == len(path_reo)-1 and len(leftovers) != []:
                # at the end of a subtitle line, check if any words still left not estimated, if so estimate based on
                # start_time (= end time of the previously aligned word), and end time of sentence.
                leftovers = estimating_words(leftovers, sw['start_time'], sw['end_time'],
                                             estimated_words_continuous_speech, estimated_words_with_aws,
                                             estimated_words_adjusted, False)




    # for transcript words that are matched, remove them from list, so they don't get duplicated in the next line if
    # the beginning of the next sentence contain the same words as the end of the previous sentence.


    # if the sentence word is aligned with 1/more transcript words, use the start of the first words it is aligned to and end ti


for words in estimated_words:
    output_table_as_ls.append([words[0], '', words[1], words[2],float(words[2]-words[1]),'full'])
for words in estimated_words_continuous_speech:
    output_table_as_ls.append([words[0], '', words[1], words[2],float(words[2]-words[1]),'continuous'])
for words in estimated_words_with_aws:
    output_table_as_ls.append([words[0], '', words[1], words[2],float(words[2]-words[1]),'partial'])
for words in estimated_words_adjusted:
    output_table_as_ls.append([words[0], '', words[1], words[2],float(words[2]-words[1]),'adjusted'])


#  order words in the onset time
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


# output_table_as_ls = ordering_words(output_table_as_ls)


#  remove words with repeated timings
for row in output_table_as_ls:
    row_index = output_table_as_ls.index(row)
    if row_index != len(output_table_as_ls) - 1:
        next_row = output_table_as_ls[row_index+1]
        if row[2] == next_row[2] and row[3] == next_row[3]:
            # same start time & end time for current & next words i.e. timing repeated
            if row[5] == 'matched':
                output_table_as_ls.remove(next_row)
            else:
                output_table_as_ls.remove(row)
row_index_shifted = []
#   correct timing for remaining words
for row in output_table_as_ls:
    row_index = output_table_as_ls.index(row)
    if row_index != len(output_table_as_ls) - 1:
        next_row = output_table_as_ls[row_index + 1]
        if row[3] > next_row[2]:
            # end time of word > start of next word. i.e. there's overlap
            if row[5] != 'matched' and next_row[5] == 'matched':
                row[3] = next_row[2]
                row_index_shifted.append(row_index)
                # if the word after is matched, use onset of next word as offset of current word
            else:
                next_row[2] = row[3]
                row_index_shifted.append(row_index+1)
                # otherwise set the onset of next word, use offset of current word as onset of next word
        row[4] = row[3]-row[2]


freq_matched = 0
freq_similar = 0
freq_est_part = 0
freq_est_cont = 0
freq_est_all = 0
freq_est_adj = 0
sum_duration_matched = 0
sum_duration_continuous = 0
sum_duration_similar = 0
sum_duration_complete = 0
sum_duration_partial = 0
sum_duration_adjusted = 0

for ls in output_table_as_ls:
    if ls[5] == 'matched':
        freq_matched+=1
        sum_duration_matched += ls[4]
    elif ls[5] == 'continuous':
        freq_est_cont +=1
        sum_duration_continuous +=ls[4]
    elif ls[5] == 'similar':
        freq_similar += 1
        sum_duration_similar+=ls[4]
    elif ls[5] == 'full':
        freq_est_all +=1
        sum_duration_complete+=ls[4]
    elif ls[5] == 'partial':
        freq_est_part+=1
        sum_duration_partial+=ls[4]
    elif ls[5] == 'adjusted':
        freq_est_adj +=1
        sum_duration_adjusted += ls[4]

total = sum([freq_est_all, freq_est_cont, freq_est_part, freq_matched,freq_similar])
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
worksheet1.write(0,9,"word_length")
worksheet1.write(0,10,"stopwords")
worksheet1.write(0,11,"shifted")

intemp = 0
for sub_word,trans_word,st,et,interval,typematch in output_table_as_ls:
    if sub_word in stopwords:
        function_word = "function"
    else:
        function_word = "not_function"
    worksheet1.write(row, col, sub_word)
    worksheet1.write(row, col+1, trans_word)
    worksheet1.write(row, col+2, st)
    worksheet1.write(row, col+3, et)
    worksheet1.write(row, col+4, interval)
    worksheet1.write(row, col+5, typematch)
    worksheet1.write(row, col+6, st)
    # if word is estimated and meet the following criteria, truncate accordingly and add to the last column
    if (typematch == 'complete_est' or 'part_est') and interval > 1 and len(sub_word)<10:
        et_new = st+0.6
        dur_new = 0.6
    elif (typematch == 'complete_est' or 'part_est') and interval > 2 and len(sub_word) > 10:
        et_new = st+1
        dur_new = 1
    else:
        et_new = et
        dur_new = interval
    worksheet1.write(row, col + 7, et_new)
    worksheet1.write(row, col + 8, dur_new)
    worksheet1.write(row, col+9, len(sub_word))
    worksheet1.write(row, col + 10, function_word)

    if intemp in row_index_shifted:
        worksheet1.write(row, col + 11, "shifted")
    else:
        worksheet1.write(row, col + 11, "not_shifted")
    intemp += 1
    row += 1


summary_stats = [['matches',freq_matched,freq_matched/total,sum_duration_matched/freq_matched],
                ['similarity',freq_similar, freq_similar/total,sum_duration_similar/freq_similar],
                ['complete',freq_est_all, freq_est_all/total, sum_duration_complete/freq_est_all],
                ['continuous',freq_est_cont,freq_est_cont/total,sum_duration_continuous/freq_est_cont],
                ['partial',freq_est_part,freq_est_part/total,sum_duration_partial/freq_est_part],
                ['adjusted',freq_est_adj,freq_est_adj/total, sum_duration_adjusted/freq_est_part]]

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



