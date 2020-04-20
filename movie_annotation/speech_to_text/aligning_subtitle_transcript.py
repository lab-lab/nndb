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
    ls_wordinfo = []
    for word in list_of_words:
        dur_word = dur_chunck*(len(word)/sum_wordlen)
        output_word = [word,start,start+dur_word]
        start = start+dur_word
        container.append(output_word)
# given the start time and end time of a list of words, estimate the st and et of each word based on letter length


def estimating_words(leftover, start, end, container_cont, container_est):
        if len(leftover) == 1:
            container_cont.append([leftover[0],start,end])
        else:
            guessing_words_fuc(leftover, start, end, container_est)

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
    final = []
    temp = []
    for item in path_reorganized_1:
        if item[1][0] in repeats:
            temp.append(item[0])
        else:
            if temp != []:
                final.append([temp, path_reorganized_1[path_reorganized_1.index(item) - 1][1]])
                temp = []
            final.append([[item[0]],item[1]])
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


print(subtitle_ls)

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
output_table = []
output_table_as_ls = []

for sw in subtitle_ls:
    # get amazon words with timings starting 0.5 sec before the start time of the sentence and ends 0.5 sec
    # after the sentence
    #print(sw['sentence_words_stemmed'])
    aw_within, aw_within_pure = [], []

    for aw in transcript_ls:
        if aw['start_time'] > sw['start_time']-0.5 and aw['end_time'] < sw['end_time']+0.5:
            aw_within.append(aw)
            aw_within_pure.append(aw['word_stemmed'])
    #print(aw_within_pure)
    # cannot do dtw if amazon don't have any words, will have to estimate based on subtitle duration and letter length
    # maybe worth removing lyrics from the subtitle or do it separately because for lyrics it seems occasions where
    # amazon didn't get anything is quite common.
    if aw_within_pure == []:
        guessing_words_fuc(sw['sentence_words'], sw['start_time'], sw['end_time'],estimated_words)

    else:
        # dtw
        # acm = accumulated cost matrix, use path here
        distance,cost,acm,path = accelerated_dtw(np.array(sw['sentence_words_stemmed']), np.array(aw_within_pure),
                                                 edit_distance, warp=1)
        #print(path)

        # at the moment it's not good at dealing with situations where one amazon word is aligned with multiple
        # subtitle words (i.e. amazon get fewer words than the subtitle), so e.g. if "this, this" in subtitle is
        # aligned with the same "this" in the transcript, the second wouldn't get a timing because it would be repeated
        # can count how many instances like these there are first ...
        path_reo = reorganize_path(path)
        #print(path_reo)
        leftovers = []   # container of words that don't have a time tag
        #print(path_reo)
        for i in range(0,len(path_reo)):
            # for each word in subtitle, create a list of amazon words it is aligned to
            aw_stemmed_words_aligned = [aw_within_pure[int(o)] for o in path_reo[i][1]]
            #print(aw_stemmed_words_aligned)
            levenshtein_similarity = []
            if len(path_reo[i][0]) == 1:
                sw_index = int(path_reo[i][0][0])
                #print(sw_index)
                for asw in aw_stemmed_words_aligned:
                    if asw == sw['sentence_words_stemmed'][sw_index]:
                        #print(asw)
                    # print(sw['sentence_words_stemmed'][i])
                    # find the index of the amazon word that matches with the subtitle words, so we can use its timing
                        aw_index = int(path_reo[i][1][aw_stemmed_words_aligned.index(asw)])
                        to_be_added = [sw['sentence_words'][sw_index], aw_within[aw_index]['start_time'],
                                       aw_within[aw_index]['end_time']]
                        if leftovers != []:
                            estimating_words(leftovers, sw['start_time'], aw_within[aw_index]['start_time'],
                                             estimated_words_continuous_speech, estimated_words_with_aws)
                            sw['start_time'] = aw_within[aw_index]['end_time']
                            leftovers = []
                        #print(to_be_added)
                        if to_be_added not in perfect_words:  # this  line  maybe unnecessary
                            perfect_words.append(to_be_added)
                            # transcript_ls.remove(aw_within[aw_index])
                            output_table.append(sw['sentence_words'][sw_index]+','+aw_within[aw_index]["word"]+','+str(aw_within[aw_index]['start_time'])+','+str(aw_within[aw_index]['end_time'])+','+str(aw_within[aw_index]['end_time']-aw_within[aw_index]['start_time'])+',perfect'+'\n')
                            output_table_as_ls.append([sw['sentence_words'][sw_index],aw_within[aw_index]["word"],aw_within[aw_index]['start_time'],aw_within[aw_index]['end_time'], aw_within[aw_index]['end_time']-aw_within[aw_index]['start_time'], 'perfect'])
                        #else:
                        #    count_instance_repeats += 1
                    # when finding a word that have an "accurate" timing, see if any words
                    # before the current word is not aligned, and if there are, estimate their timing. and
                    # clear the leftovers container


                        # change the "start time" of the sentence to be used for estimating timings for words not aligned


                    # remove words that are perfectly aligned with the subtitle word so it doesn't go into another
                    # subtitle line
                    else:
                        # if it is not the same, take a record of the similarity between the sentence word and
                        # transcript word, if the highest similarity between a subtitle word and the amazon word
                        # it's aligned to is above a threshold (say 90%), use the timing of the amazon word

                        levenshtein_similarity.append(jaro(sw['sentence_words_stemmed'][i],asw))
                        if len(levenshtein_similarity) == len(aw_stemmed_words_aligned):  # when all transcripts words aligned with the subtitle words have their similarity scores calculated
                            if max(levenshtein_similarity) > 0.6:
                                # if the max similarity between the word in the subtitle is not
                                sw_index = int(path_reo[i][0][0])
                                aw_index = int(path_reo[i][1][levenshtein_similarity.index(max(levenshtein_similarity))])
                                if leftovers != []:
                                    print(leftovers)
                                    estimating_words(leftovers, sw['start_time'], aw_within[aw_index]['start_time'],
                                                     estimated_words_continuous_speech, estimated_words_with_aws)
                                    sw['start_time'] = aw_within[aw_index]['end_time']
                                    leftovers = []
                                #print(sw)
                                #print(aw_index)
                                to_be_added = [sw['sentence_words'][sw_index], aw_within[aw_index]['start_time'],
                                               aw_within[aw_index]['end_time']]
                                output_table.append(sw['sentence_words'][sw_index] + ',' + aw_within[aw_index]["word"] + ',' + str(aw_within[aw_index]['start_time']) + ',' + str(aw_within[aw_index]['end_time'])+ ','+str(aw_within[aw_index]['end_time'] - aw_within[aw_index]['start_time'])+',similar'+'\n')
                                output_table_as_ls.append([sw['sentence_words'][sw_index],aw_within[aw_index]["word"],aw_within[aw_index]['start_time'],  aw_within[aw_index]['end_time'], aw_within[aw_index]['end_time'] - aw_within[aw_index]['start_time'],'similar'])
                                estimated_words_similar_match.append(to_be_added)
                                # print([aw_within[aw_index]['word'],sw['sentence_words'][i]])
                                # same as above

                            # if subtitle word not matched with anything, make record of it.

                            else:
                                leftovers.append(sw['sentence_words'][sw_index])

            # if multiple subtitle words are aligned to one transcript word, estimate the timing based on the match:
            # if one & only one word is matched perfectly with the transcript word, take its timing and estimate the rest
            # if no perfect match but have "similar" match, use the timing of the most similar and estimate the rest
            # if none of the above, estimate all
            # how can i simplify it?

            else:
                sw_indexes = [y for y in path_reo[i][0]]
                sw_words_stemmed = [sw['sentence_words_stemmed'][index] for index in sw_indexes]
                sw_words = [sw['sentence_words'][index] for index in sw_indexes]
                print(sw_words)
                aw_index = path_reo[i][1][0]
                aw = aw_within[aw_index]["word_stemmed"]
                print(aw)
                perfect_w = [w for w in sw_words_stemmed if w == aw]
                for words in sw_words_stemmed:
                    levenshtein_similarity.append(jaro(words,aw))
                print(levenshtein_similarity)

################  should we use stemming when comparing similarity? #########################
                if len(perfect_w) > 1 or (len(perfect_w) == 0 and max(levenshtein_similarity)<.6):
                    for w in sw_words:
                        leftovers.append(w)
                # if more than one perfect matches estimate all

                elif len(perfect_w) == 1:
                    for index in sw_indexes:
                        if sw['sentence_words_stemmed'][index] in perfect_w:
                            if leftovers != []:
                                estimating_words(leftovers, sw['start_time'], aw_within[aw_index]['start_time'],
                                                 estimated_words_continuous_speech, estimated_words_with_aws)
                                sw['start_time'] = aw_within[aw_index]['end_time']
                                leftovers = []

                            to_be_added = [sw['sentence_words'][index], aw_within[aw_index]['start_time'],
                                           aw_within[aw_index]['end_time']]
                            perfect_words.append(to_be_added)
                        else:
                            leftovers.append(sw['sentence_words'][index])
                # if only one perfect match use its timing and estimate others

                elif len(perfect_w) == 0:
                        sw_index = sw_indexes[levenshtein_similarity.index(max(levenshtein_similarity))]
                        for index in sw_indexes:
                            if index == sw_index:
                                #print(leftovers)
                                if leftovers != []:
                                    estimating_words(leftovers, sw['start_time'], aw_within[aw_index]['start_time'],
                                                     estimated_words_continuous_speech, estimated_words_with_aws)
                                    sw['start_time'] = aw_within[aw_index]['end_time']
                                    leftovers = []
                                to_be_added = [sw['sentence_words'][sw_index], aw_within[aw_index]['start_time'],
                                               aw_within[aw_index]['end_time']]
                                estimated_words_similar_match.append(to_be_added)
                            else:
                                leftovers.append(sw['sentence_words'][index])

###can be simplified a lot

            if i == len(path_reo)-1:
                # at the end of a subtitle line, check if any words still left not estimated, if so estimate based on
                # start_time (= end time of the previously aligned word), and end time of sentence.
                if len(leftovers) != []:
                    estimating_words(leftovers, sw['start_time'], sw['end_time'],
                                     estimated_words_continuous_speech, estimated_words_with_aws)

                    leftovers = []



    # for transcript words that are matched, remove them from list, so they don't get duplicated in the next line if
    # the beginning of the next sentence contain the same words as the end of the previous sentence.


    # if the sentence word is aligned with 1/more transcript words, use the start of the first words it is aligned to and end ti


for words in estimated_words:
    output_table.append(words[0]+', ,'+str(words[1])+','+str(words[2])+','+str(words[2]-words[1])+',complete_est\n')
    output_table_as_ls.append([words[0], '', words[1], words[2],str(words[2]-words[1]),'complete_est'])
for words in estimated_words_continuous_speech:
    output_table_as_ls.append([words[0], '', words[1], words[2],str(words[2]-words[1]),'continuous'])
    output_table.append(words[0]+', ,'+str(words[1])+','+str(words[2])+','+str(words[2]-words[1])+',continuous\n')
for words in estimated_words_with_aws:
    output_table_as_ls.append([words[0], '', words[1], words[2],str(words[2]-words[1]),'part_est'])
    output_table.append(words[0]+', ,'+str(words[1])+','+str(words[2])+','+str(words[2]-words[1])+',part_est\n')

with open('output_table.txt','w') as f:
    for rows in output_table:
        f.write(rows)



freq_perfect = 0
freq_similar = 0
freq_est_part = 0
freq_est_cont = 0
freq_est_all = 0

for ls in output_table_as_ls:
    if ls[5] == 'perfect':
        freq_perfect+=1
    elif ls[5] =='continuous':
        freq_est_cont +=1
    elif ls[5] =='similar':
        freq_similar += 1
    elif ls[5] == 'complete_est':
        freq_est_all +=1
    elif ls[5] == 'part_est':
        freq_est_part+=1

total = sum([freq_est_all, freq_est_cont, freq_est_part, freq_perfect,freq_similar])
