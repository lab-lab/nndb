import sys, os, json, time
import gensim
import retinasdk
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.cm as cm

from import_functions import *
from clustering_functions import *
from visualise_clusters import cloud_words


## TO DO ##
# 3. compare centroids from words vs labels
# 4. Figure out how to do cluster allocation with the clusters obtained
# TRY THIS FUNCTION model.doesnt_match("breakfast cereal dinner lunch";.split())
def w2vec_vocab(model):
	all_vectors = []
	for word in model.wv.vocab:
		all_vectors.append(model.wv[word])
	return np.array(all_vectors)

# returns a semantic vector from the Retina API
# some words get smaller-sized vectors - no idea why
# to be able to remain consistent, we only use those who have the standard 328-"vector"
# "" used because I'm not sure it's a vector in the same way word2vec outputs vectors
def retina_generate_vectors(liteClient, words):
	words_to_cluster = []
	for word in words:
		try:
			words_to_cluster.append(liteClient.getFingerprint(word))
		except:
			print("Oooops, couldn't find: %s" % word)
	output = [elem for elem in words_to_cluster if len(elem) == 328]
	c = 0
	for word in words_to_cluster:
		if len(word) != 328:
			c += 1
	return np.array(output)

# returns an array with a 300-dim vector for each word 
def word2vec_generate_vectors(model, word_list):
	word_vectors = []
	known_words = model.wv
	unknown_words = []
	for word in word_list:
		if word in known_words.vocab:
			word_vectors.append(model.wv[word])
		else:
			unknown_words.append(word)

	return np.array(word_vectors), unknown_words


def cluster_assignment(annotation_list, timeline, clusters):
	periods_detected = []
	for line in annotation_list:
		no_of_periods = 0
		for i in range(len(timeline)-1):
			period_start = timeline[i][0]*10
			period_end = timeline[i][0]*10 + 10
			label_is_there = False

			# timings from annotations will be in miliseconds
			# turnt that into seconds
			#print(type(line["start"]), type(line["end"]))

			if line["start"]/1000 >= period_start and line["end"]/1000 <= period_end:
				label_is_there = True
			elif line["start"]/1000 <= period_start and line["end"]/1000 >= period_end:
				label_is_there = True
			elif line["start"]/1000 <= period_start and line["end"]/1000 <= period_end:
				label_is_there = True
			
			# word is in that 10s period
			if label_is_there:	
				cluster_assigned = False
				for j, clust in enumerate(clusters):
					if line["word"] in clust and not cluster_assigned:
						timeline[i][j+1] += 1
						cluster_assigned = True
					elif line["word"] in clust and cluster_assigned:
						print("Word in 2 clusters - 404")

				no_of_periods += 1
		# for each appearance, we want to count in how many periods it was detected
		# just to see if the numbers make sens
		periods_detected.append(no_of_periods)

	return timeline, periods_detected



# how clusters vary across time
# this works by taking all the words into account - both spoken language and labels
def clusters_across_time(clusters, word_list, gc_list, aws_list):
	# 547 is for 500days of summer
	timeline = [[i,] for i in range(0, 547)]
	# need an array of the length of each cluster in each 10s period
	for i in range(len(timeline)):
		timeline[i].extend([0 for j in range(len(clusters))])

	print("Visualisation timeline: ", len(timeline))
	print("Number of clusters: ", len(clusters))
	print("Len of first period ", len(timeline[0]))
	timeline, periods_per_app_wd = cluster_assignment(word_list, timeline, clusters)
	timeline, periods_per_app_gc = cluster_assignment(gc_list, timeline, clusters)
	timeline, periods_per_app_aws= cluster_assignment(aws_list, timeline, clusters)

	print("Words periods: ")
	for wd in periods_per_app_wd:
		print(wd)

	output = {"timeline":[]}
	for i in range(len(clusters)):
		name = "cluster" + str(i)
		output["timeline"].append({"%s" %(name): [], "word number": len(clusters[i])})

	for i, clust in enumerate(output["timeline"]):
		for j in range(len(timeline)):
			clust_name = "cluster" + str(i)
			clust[clust_name].append(timeline[j][i+1])

	with open("cluster_timeline.json", "w") as f:
		json.dump(output, f)


def main(args):

	movie_name = input("Movie name: ")
##### IMPORT DATA ######
	movie_words, unique_words = import_words("context_analysis/data/" + movie_name + "_words_warped.txt")
	google_args = ["google/data/" + movie_name + "_gc_full_labels_1.json", 
			"google/data/" + movie_name + "_gc_full_labels_2.json",
			"google/data/" + movie_name + "_gc_full_labels_3.json"]

	gc_labels, unique_gc_labels = import_google_labels(google_args)
	aws_labels, unique_aws_labels = import_aws_labels("context_analysis/data/" + movie_name + "_aws_labels.json")

##### INITIALISE MODELS ######
	liteClient = retinasdk.LiteClient("557d9940-40ab-11e8-9172-3ff24e827f76")
	semantic_model = gensim.models.KeyedVectors.load_word2vec_format('GoogleNews-vectors-negative300.bin', binary=True, limit=500000)

##### Vectorize words ######
	# returns embeddings vectors for every word in the w2v vocabulary
#	word2vec_whole_vectors = w2vec_vocab(semantic_model)

	word2vec_word_vectors, unknown_words = word2vec_generate_vectors(semantic_model, unique_words)
	word2vec_gc_vectors, unknown_gc_labels = word2vec_generate_vectors(semantic_model, unique_gc_labels)
	word2vec_aws_vectors, unknown_aws_labels = word2vec_generate_vectors(semantic_model, unique_aws_labels)

##### Make sure numbers add up ######
	print("Word vectors: ", len(word2vec_word_vectors))
	print("GC vectors:", len(word2vec_gc_vectors))
	print("AWS vectors", len(word2vec_aws_vectors))
	all_labels_vectors = np.concatenate((word2vec_word_vectors, word2vec_gc_vectors, word2vec_aws_vectors))
	print("All vectors:", len(all_labels_vectors))

#	retina_word_vectors = retina_generate_vectors(liteClient, words)

##### CLUSTER ESTIMATION #######
#	estimate_elbow_cluster_num(all_labels_vectors)
#	for i in range(30, 36):
#		print("Num of clusters" + str(i))
#		estimate_silhou_cluster_num(all_labels_vectors, i)

#### PCA #######
#	do_PCA(all_labels_vectors)

#### CLUSTERING METHODS #######
#	cluster_kmeans(all_labels_vectors, semantic_model)
#	cluster_agglom(word2vec_word_vectors, semantic_model)
	cluster_components = cluster_agglom(all_labels_vectors, semantic_model)

	clusters_across_time(cluster_components, movie_words, gc_labels, aws_labels)

	print("Done")

if __name__ == "__main__":
	main(sys.argv[1:])

