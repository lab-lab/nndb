import sys, os
import pysrt
import transcribed_audio_pb2 as transcribed_audio
import numpy as np
import json

from dtw import fastdtw
from nltk.metrics.distance import edit_distance



# parses the Amazon JSON that contains the transcript and returns the text and then an array [start, end, word, confidence]
def amazon_transcript(file_name):

	am_transcript = {"text": None, "words": []}

	with open(file_name) as f:
		data = json.load(f)
		am_transcript["text"] = data["results"]["transcripts"][0]
		for item in data["results"]["items"]:
			am_transcript["words"].append(item)
	timings = []
	for i in range(len(am_transcript["words"])):
		if am_transcript["words"][i]["type"] == "pronunciation":
			timings.append([am_transcript["words"][i]["start_time"], am_transcript["words"][i]["end_time"], am_transcript["words"][i]["alternatives"][0]["content"], am_transcript["words"][i]["alternatives"][0]["confidence"]])

	#print(am_transcript["text"])

	return am_transcript["text"]["transcript"], timings 

# returns timings from the Google Speech-to-Text transcript stored in a protobuf file
def get_time_transcript(transcript_bits):

	times = []

	for tran in transcript_bits:
		times.append({"text": tran.text, "words": tran.words})

	output = [] 

	for transcript in times:
		output.extend([[float(time.start), float(time.stop)] for time in transcript["words"]])		

	return np.array(output)



# returns an array of all the words in the transcript in chronological order
# amazon tells us whether the input is from the amazon JSON or not (the other text is in sentences, not a single string)
def get_text_ready(audiobit_collection, amazon):

	sentenced_transcript = []

	if amazon == False:
		for tran in audiobit_collection:
			sentenced_transcript.append(tran.text)
	else:
		sentenced_transcript.append(audiobit_collection)

	temp_transcript = [sentence.split(" ") for sentence in sentenced_transcript]
	words_transcript = []

	for sentence in temp_transcript:
		words_transcript.extend(sentence)

	words_transcript = [word for word in words_transcript if word != '']
	words_transcript = [word.strip("</") for word in words_transcript]
	words_transcript = [word.strip("\n") for word in words_transcript]
	words_transcript = [word.strip("\n-") for word in words_transcript]
	words_transcript = [word.strip('"') for word in words_transcript]
	words_transcript = [word.strip("'") for word in words_transcript]
	words_transcript = [word.strip("#") for word in words_transcript]
	words_transcript = [word.strip(",,,") for word in words_transcript]
	words_transcript = [word.strip("...") for word in words_transcript]
	words_transcript = [word.lower() for word in words_transcript if word != "-"]

	for i in range(len(words_transcript)):
		if "\n" in words_transcript[i]:
			words_transcript[i] = words_transcript[i].replace("\n", ' ')

	words_transcript = [word.split(" ") for word in words_transcript]
	final_words_transcript = []

	for word in words_transcript:
		final_words_transcript.extend(word)

	#final_words_transcript = [word.strip("<i>") for word in final_words_transcript if word != '']
	final_words_transcript = [word.strip("</") for word in final_words_transcript]
	final_words_transcript = [word for word in final_words_transcript if word != " "]
	final_words_transcript = [word for word in final_words_transcript if word != ""]
	final_words_transcript = [word.strip("?") for word in final_words_transcript]
	final_words_transcript = [word.strip("!") for word in final_words_transcript]
	final_words_transcript = [word.strip("-") for word in final_words_transcript]
	final_words_transcript = [word.strip(".") for word in final_words_transcript]
	final_words_transcript = [word.strip("'") for word in final_words_transcript]
	final_words_transcript = [word.strip('"') for word in final_words_transcript]
	final_words_transcript = [word.strip(",") for word in final_words_transcript]
	final_words_transcript = [word for word in final_words_transcript if word != ""]

	#print(final_words_transcript)
	return np.array(final_words_transcript)

# goes through the path given by the DTW algorithm
# it sees which way it should go on the grid - UP, RIGHT or DIAGONALLY
# starts at 0,0
# returns a list in which each pair has [index of series 1, index of series 2]
######  Note   #######
# when moving up or to the right (i.e. one value from one series corresponds to multiple values from the other series)
# we put these pairs together into one list that will appear as a collection of pairs into the list of pairs
def find_timings_for_words(path):

	list_of_pairs = [[[path[0][0], path[1][0]]]]

	c = 0
	path_zero = [elem for elem in path[0]]
	path_one = [elem for elem in path[1]]
	d = 0

	for i, j in zip(path[0][1:], path[1][1:]):

		previous_pair = [path[0][d], path[1][d]]
		# moving forward vertically the grid (UP)
		if i == previous_pair[0] + 1 and j == previous_pair[1]:
			list_of_pairs[c].append([i, j])

		# moving forward horizontally (RIGHT)
		elif i == previous_pair[0] and j == previous_pair[1] + 1:
			list_of_pairs[c].append([i, j])

		# moving on the diagonal
		elif i != previous_pair[0] and j != previous_pair[1]:
			list_of_pairs.append([[i, j]])
			c += 1

		# should never enter this else
		else:
			print("Hmm", previous_pair[0], i, previous_pair[1], j)

		d += 1

	return list_of_pairs

# checks whether every element in the list is the same
def checkEqual(lst):
	return lst[1:] == lst[:-1]

def output_timings(company, path, subs, transcript, timings):
	a = 0
	with open("%s_timings_for_words.txt" % company, "w") as output:
		for pair in path:
			# when there's a 1-1 match:
			if len(pair) == 1:

				sub_word = subs[pair[0][0]]
				transcript_word = transcript[pair[0][1]]
				a += 1

				if company == "google":
					output.write("UN_" + sub_word + " " + transcript_word + " " + str(timings[pair[0][1]]) + "\n")
				else:
					output.write("UN_" + sub_word + " " + transcript_word + " " + str(timings[pair[0][1]][0] + " " + timings[pair[0][1]][1]) + "\n")

			# when there a 1-many match:
			else:
				sub_words = [subs[ind[0]] for ind in pair]
				transcript_words = [transcript[ind[1]] for ind in pair]
			
				if checkEqual(sub_words):
					sub_output = sub_words[0]

				if checkEqual(transcript_words):
					transcript_words = transcript_words[0]					

				if company == "google":
					output.write("MU_" + str(sub_words) + " " + str(transcript_words) + " " + str(timings[pair[0][1]]) + "\n")
				else:
					output.write("MU_" + str(sub_words) + " " + str(transcript_words) + " " + str(timings[pair[0][1]][0] + " " + timings[pair[0][1]][1]) + "\n")

	print("For the %s transcript, we have %d unique words with timings out of %d DTW matches." % (company, a, len(path)))
	print("All done, folks!")

def parse_subs(file_name):
	return pysrt.open(file_name, encoding="utf-8")
	
def load_proto_file(file_name):

	f = open(file_name, "rb")
	audio_collection = transcribed_audio.AudioCollection()
	audio_collection.ParseFromString(f.read())
	f.close()

	return audio_collection

def main():
	print("Gill Bates vs Beff Jezos")
	print("Who's going to win?")
	#subtitle_file = input("Subtitles SRT:  ")
	#transcript_file = input("Google Protobuf transcript:  ")
	#amazon_file = input("Amazon JSON transcript: ")

	subtitle_file = "500_days.srt"
	transcript_file = "500_days_transcribed_audio.pb"
	amazon_file = "500_days_amazon.json"

	# load the data	
	transcript_collection = load_proto_file(transcript_file)
	subs = parse_subs(subtitle_file)
	amazon_text, amazon_timings = amazon_transcript(amazon_file)
	google_timings = get_time_transcript(transcript_collection.audiobits)

	# get text data ready for processing
	subs_align = get_text_ready(subs, False)
	tran_google = get_text_ready(transcript_collection.audiobits, False)
	tran_amazon = get_text_ready(amazon_text, True)

	print("Starting the alignment...")
	dist, cost, acc, path = fastdtw(np.array(subs_align), np.array(tran_google), edit_distance)
	print("Finished warping ONE")
	dist2, cost2, acc2, path2 = fastdtw(np.array(subs_align), np.array(tran_amazon), edit_distance)
	print("Finished warping TWO. Starting aligning...")

	# find the path from 0,0 to the end to get the timings	
	google_path_pairs = find_timings_for_words(path)
	amazon_path_pairs = find_timings_for_words(path2) 
	
	output_timings("google", google_path_pairs, subs_align, tran_google, google_timings)
	output_timings("amazon", amazon_path_pairs, subs_align, tran_amazon, amazon_timings)


if __name__ == "__main__":
	main()





