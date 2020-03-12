import json
import numpy as np
from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize
import math

# used to import any kind of json data
def import_json_data(name):
	with open('/home/fgheorghiu/initial_tests/' + name, "r") as f:
		data = json.load(f)
	return data

def import_aws_labels(name):

	start = []
	word = []
	end = []
	confidence = []
	# omg so special
	unique = []

	data = import_json_data(name)
	
	for app in data:
                # app["object"] is an array - at the moment get just the first element 
                # TO DO - find a clever way to do an average
#               movie_labels.append([app["object"][0].lower(), app['start'], app['end']])
		word.append(app["object"][0].lower())
		start.append(app["start"])
		end.append(app["end"])
		confidence.append(app["confidence"])
		if app["object"][0].lower() not in unique:
			unique.append(app["object"][0].lower())

	records = np.rec.fromarrays((word, start, end, confidence), names=('word', 'start', 'end', 'confidence'))
	movie_labels = [word for word in records if word[0] != "person"]
	movie_labels = [word for word in movie_labels if word[0] != "human"]
	movie_labels = [word for word in movie_labels if word[0] != "face"]
	movie_labels = [word for word in movie_labels if word[0] != "head"]

	return movie_labels, unique

# should we tokenize? not sure          
def import_words(name):
	stop_words = set(stopwords.words('english'))
	stop_words = list(stop_words)

	words_to_process = []
	words_timings = []
	words = []
	start = []
	end = []
	unique = []

	with open('/home/fgheorghiu/initial_tests/' + name, "r") as input_file:
		for line in input_file.readlines():
			temp_words = line.strip("\n")
			temp_words = temp_words.split(" ")
			words_to_process.append(temp_words[0])
			words_timings.append([temp_words[-2], temp_words[-1]])

	for i in range(0, len(words_to_process)):
		if "MU" not in words_to_process[i]:
			if word_tokenize(words_to_process[i].strip("UN_"))[0] not in stop_words:
				word = word_tokenize(words_to_process[i].strip("UN_"))[0]
				start_time = 1000*int(words_timings[i][0].split(".")[0]) + int(words_timings[i][0].split(".")[1])
				end_time = 1000*int(words_timings[i][1].split(".")[0]) + int(words_timings[i][1].split(".")[1])
				words.append(word)
				start.append(start_time)
				end.append(end_time)
				if word not in unique:
					unique.append(word)

	word_list = np.rec.fromarrays((words, start, end), names=('word', 'start', 'end'))

	return word_list, unique

# deals with a variable number of milis from gc labels
def reconstruct_milis(milis):
	if len(milis) == 1:
		milis = int(milis)* 100
	elif len(milis) == 2:
		milis = int(milis)*10
	else:
		milis = int(milis[0:3])

	return milis

# imports labels obtained from the GC Video Intelligence API
# when the segment timings are within the same .1 seconds, we take that as a fluke
def import_google_labels(args):
	data = []
	parts_to_add = [0]
	for i in range(1, len(args)):
		parts_to_add.append(i*30*60)

	for i, arg in enumerate(args):
		gc_data = import_json_data(arg)
		for j in range(0, len(gc_data)):
			gc_data[j]['segment'][0] += parts_to_add[i]
			gc_data[j]['segment'][1] += parts_to_add[i]

		data.extend(gc_data)

	unique = []
	quacks = 0
	word = []
	end = []
	start = []
	confidence = []
	for obj in data:
		if obj["segment"][0] != obj["segment"][1]:
			frac1, whole1 = math.modf(obj["segment"][0])
			frac2, whole2 = math.modf(obj["segment"][1])

			milis_1 = reconstruct_milis(str(frac1).split(".")[1])
			milis_2 = reconstruct_milis(str(frac2).split(".")[1])

			word.append(obj["label"])
			start.append(int(whole1)*1000 + milis_1)
			end.append(int(whole2)*1000 + milis_2)
			confidence.append(obj["confidence"])
			if obj["label"] not in unique:
				unique.append(obj["label"])
		else:
			quacks += 1

	records = np.rec.fromarrays((word, start, end, confidence), names=('word', 'start', 'end', 'confidence'))

	movie_labels = [word for word in records if word["word"] != "person"]
	movie_labels = [word for word in movie_labels if word["word"] != "face"]
	movie_labels = [word for word in movie_labels if word["word"] != ""]

	return movie_labels, unique



