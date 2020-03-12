# We used different word embeddings models to quantify semantic similarity based on word frequency in large corpi of text
# Word2Vec, Numenta's Retina API and Glove

import sys, os, json, math
import gensim
import retinasdk
import numpy as np
import matplotlib.pyplot as plt
from import_functions import *

# TO DOS
# 1. not very important - Add the Retina similarity measure as well
# 3. Add words themselves in the similarity to be included in the context scores

def get_cortical_similarity(liteClient, word1, word2):
	# to compare two words on semantic similarity
	try:
		sim = liteClient.compare(word1, word2)
	except:
		sim = 0
		print("Oooops, couldn't find either of these: %s %s" %(word1, word2))

	return sim


# need a function to compute context based on past words
# what's a good proxy for that? Surprisal, most likely. Fucking Diego

# need to make sure the words and labels matrices contain the time of these things
def context_words_and_labels(similarity_matrix, words, labels):
	words_deconvolution = []
	for word in words:
		words_deconvolution.append({"word": word[0], "start": word[1], "end": word[2], "context_score": 0, "accum_scores": {"duration": 0, "distance": 0, "semantic_sim": 0}, "appearances":[]})

	for i in range(similarity_matrix.shape[0]):
		for j in range(similarity_matrix.shape[1]):
		
			if similarity_matrix[i, j] > 0.3:
				# now we check time
				if int(words[i][1]) > int(labels[j][2]):
					distance = int(words[i][1]) - int(labels[j][2])
					duration = int(labels[j][2]) - int(labels[j][1])
					semantic_sim = float(similarity_matrix[i,j])
					context_score = (float(duration)*100)/(float(distance)*semantic_sim)

					valid_appearance = {"distance": distance, "duration": duration, "semantic_sim": semantic_sim, "label": labels[j][0]}
					words_deconvolution[i]["appearances"].append(valid_appearance)
					words_deconvolution[i]["accum_scores"]["duration"] += duration
					words_deconvolution[i]["accum_scores"]["distance"] += distance
					words_deconvolution[i]["accum_scores"]["semantic_sim"] += semantic_sim
					words_deconvolution[i]["context_score"] += context_score

	return words_deconvolution


def generate_similarity_matrix(model, list_1, list_2, matrix):
	for i in range(matrix.shape[0]):
		for j in range(matrix.shape[1]):
			#print(list_1[i], list_2[j])
			sim = model.similarity(list_1[i].decode("UTF-8"), list_2[j].decode("UTF-8"))
			matrix[i,j] = sim
	return matrix

def label_overlap(labels_1, labels_2, model):
	labels_that_match = 0
	labels_mismatch = 0
	labels_match_list = []
	labels_nomatch_list = []
	# calculate overlap of labels
	for i in range(len(labels_1)):
		for j in range(len(labels_2)):

			if labels_1[i][1] >= labels_2[j][1] and labels_1[i][1] <= labels_2[j][2]:
				timing_matched = True
			elif labels_1[i][2] >= labels_2[j][1] and labels_1[i][2] <= labels_2[j][2]:
				timing_matched = True
			else:
				timing_matched = False

			if labels_1[i][0] == labels_2[j][0]:
				label_matched = True
			else:
				label_matched = False

			if timing_matched and label_matched:
				labels_that_match +=1
				labels_match_list.append([labels_1[i][0], labels_2[j][0], labels_1[i][1], labels_2[j][1], labels_1[i][2], labels_2[j][2]])
			elif timing_matched and not label_matched:
				labels_mismatch +=1
				labels_nomatch_list.append([labels_1[i][0], labels_2[j][0], labels_1[i][1], labels_2[j][1], labels_1[i][2], labels_2[j][2]])

	print("GC, AWS", len(labels_1), len(labels_2))
	print(labels_that_match)
	print(labels_mismatch)
	for lab in labels_nomatch_list:
		print(lab[0], lab[1])
		print(lab[2], lab[4])
		print(lab[3], lab[5])
		print("--------------")
		print("\n")

	# calculate timing disagreement
#	timeline = []
#	nothing_there = 0
#	perfect_match = 0
#	for i in range(0, 5470000, 100):
#		temp_gc_labels = []
#		temp_aws_labels = []
#		for gc_app in labels_1:
#			if i >= gc_app["start"] and i <= gc_app["end"]:
#				temp_gc_labels.append(gc_app["word"])
#		for aws_app in labels_2:
#			if i >= aws_app["start"] and i <= aws_app["end"]:
#				temp_aws_labels.append(aws_app["word"])
#		# when the timepoint is empty
#		if len(temp_gc_labels) == 0 and len(temp_aws_labels) == 0:
#			timeline.append([str(i), "nada"])
#			nothing_there += 1
#		elif temp_gc_labels == temp_aws_labels:
#			timeline.append([str(i), "perfect match"])
#			perfect_match += 1
#		else:
#			timeline.append([str(i), " ".join(temp_gc_labels), "|", " ".join(temp_aws_labels)])
#
#	with open("crazy_timeline.txt", "w") as f:
#		for i in timeline:
#			f.write(" ".join(i))
#			f.write("\n")

def analyse_context_distribution(word_list):
	time = []
	context_scores = []
	appearances = []
	no_context = 0
	app_num = 0
	app_duration = 0
	app_sem = 0
	top_words = [["wd", 0], ["wd", 0], ["wd", 0], ["wd", 0], ["wd",0],
			["wd", 0], ["wd", 0], ["wd", 0], ["wd", 0], ["wd",0]]
	for i, word in enumerate(word_list):
		time.append(word["start"])	
		context_scores.append(word["context_score"])
		appearances.append(len(word["appearances"]))
		if word["context_score"] == 0:
			no_context += 1
		if len(word["appearances"]) > 0:
			app_num += len(word["appearances"])
			app_duration += sum([app["duration"]  for app in word["appearances"]])/len(word["appearances"])
			app_sem += sum([app["semantic_sim"] for app in word["appearances"]])/len(word["appearances"])
			temp_app_sem = sum([app["semantic_sim"] for app in word["appearances"]])/len(word["appearances"])
			if temp_app_sem > top_words[0][1]:
				top_words[0] = [word["word"], temp_app_sem, [app["label"] for app in word["appearances"]]]
				top_words.sort(key=lambda x: x[1])
	# OVERALL STATs
	print("Wrds with no context: ", no_context)
	print("Wrds with context: ", len(word_list) - no_context)
	print("Mean number of appearances: ", app_num/(len(word_list) - no_context))
	print("Mean duration per word: ", app_duration/(len(word_list) - no_context))
	print("Mean SemSim per word: ", app_sem/(len(word_list) - no_context))


	with  open("citizenfour_top_words.txt", "w") as f:
		for word in top_words:
			f.write(word[0] + str(word[1]) + " labels "+ " ".join(word[2]) + "\n")
	# what are we interested in?
	# OVERALL - distribution of context score
#	plt.figure(figsize=(30, 8), dpi=80)
#	plt.scatter(time, context_scores, color='r')
#	plt.xlabel('Time')
#	plt.ylabel('Context Scores')
#	plt.savefig("context_over_time.png")
#	plt.close()

	# Scatter PLOT - as time vs number of appearances
#	plt.figure(figsize=(30, 8), dpi=80)
#	plt.scatter(time, appearances, color='r')
#	plt.xlabel('Time')
#	plt.ylabel('Number of appearances')
#	plt.savefig("appearances_over_time.png")


def main():
	print("It's a wild combination.")

#	liteClient = retinasdk.LiteClient("557d9940-40ab-11e8-9172-3ff24e827f76")
	model = gensim.models.KeyedVectors.load_word2vec_format('GoogleNews-vectors-negative300.bin', binary=True, limit=500000)
	print("w2v loaded")

	movie_words, unique_words = import_words("context_analysis/data/500days_words_warped.txt")
	temp_args = ["google/data/500days_gc_labels_1.json",
                        "google/data/500days_gc_labels_2.json",
                        "google/data/500days_gc_labels_3.json"]

	gc_labels, unique_gc = import_google_labels(temp_args)
	aws_labels, unique_aws = import_aws_labels("context_analysis/data/500_aws_labels.json")

	# NEED TO DEVELOP THIS FUNCTION
	overlap = False
	if overlap:
		label_overlap(gc_labels, aws_labels, model)

	object_labels = gc_labels
	for it in aws_labels:
		object_labels.append(it)

	print("Words shape ", movie_words.shape)
	print("Labels shape", object_labels.shape)

	print("Before vocab check", len(movie_words), len(object_labels))
	words_ready = [word for word in movie_words if word[0] in model.wv.vocab]
	labels_ready = [label for label in object_labels if label[0] in model.wv.vocab]
	print("After vocab check", len(words_ready), len(labels_ready))

	labels_ready.sort(key=lambda x: x[1])


#	print(type(labels_ready[0][0]), type(labels_ready[0][1]), type(labels_ready[0][2]))
	words_ready = np.array(words_ready, dtype=[('word', '|S30'), ('start', 'i8'), ('end', 'i8')])
	labels_ready = np.array(labels_ready, dtype=[('word', '|S30'), ('start', 'i8'), ('end', 'i8'), ('confidence', 'f4')])
#	print(words_ready['word'])
	print(words_ready[0], type(words_ready[0][0]), type(words_ready[0][1]))
	print(labels_ready[0], type(labels_ready[0][0]), type(labels_ready[0][1]))

	#print(words_ready.shape[0], labels_ready.shape[0])

	similarity_matrix = np.empty((len(words_ready), len(labels_ready)))
	similarity_matrix = generate_similarity_matrix(model, words_ready['word'], labels_ready['word'], similarity_matrix)

	contexted_words = context_words_and_labels(similarity_matrix, words_ready, labels_ready)

	with open("500new_words_contexted.json", "w") as f:
		json.dump(contexted_words, f)

#	analyse_context_distribution(contexted_words)
	print("I wanna drink some chlorophyl")

if __name__ == "__main__":
	main()

# these are for when you do a correlation matrix for objects to see the similarity between labels
#	summary = np.triu(similarity_matrix, 0)
#	stats = []
#	print(summary.shape)
#	a = summary.shape[1] - 1
#	for i in range(summary.shape[0]):
#		for j in range(summary.shape[1] - a, summary.shape[1]):
#			stats.append(summary[i,j])
#		a = a - 1
#	print(len(stats))
#	stats = [num for num in stats if num < 0.9999]
#	print("---------------")
#	print(len(words), len(stats))
#	print(np.amin(np.array(stats)))
#	print(np.amax(np.array(stats)))
#	print(np.median(np.array(stats)))
#	print(np.mean(np.array(stats)))
#	print(np.std(np.array(stats)))
