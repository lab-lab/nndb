import os, sys
import nltk
from nltk.corpus import stopwords
import numpy as np

def get_words_for_analysis(words, remove_stopwords, pos_tags):

	unique_words = []
	words_not_matching = 0

	# get only the words that have a unique match from the DTW analysis
	for i in range(len(words)):
		if "UN" in words[i]:
			word1 = words[i].split(" ")[0]
			word1 = word1.split("_")[1]
			word2 = words[i].split(" ")[1] 
			
			if word1 == word2:
				start = float(words[i].split(" ")[2].strip("[") + "0")
				end = float(words[i].split(" ")[3].strip("]") + "0")

				unique_words.append([word1, start, end])
			else:
				# count the mismatch and give us the words
				words_not_matching += 1

	# remove stopwords
	if remove_stop_words == True:
		stop_words = set(stopwords.words("english"))
		other_stopwords = [ "a", "about", "above", "after", "again", "against", "all", "am", "an", "and", "any", "are", "as", "at", "be", "because", "been", "before", "being", "below", "between", "both", "but", "by", "could", "did", "do", "does", "doing", "down", "during", "each", "few", "for", "from", "further", "had", "has", "have", "having", "he", "he'd", "he'll", "he's", "her", "here", "here's", "hers", "herself", "him", "himself", "his", "how", "how's", "i", "i'd", "i'll", "i'm", "i've", "if", "in", "into", "is", "it", "it's", "its", "itself", "let's", "me", "more", "most", "my", "myself", "nor", "of", "on", "once", "only", "or", "other", "ought", "our", "ours", "ourselves", "out", "over", "own", "same", "she", "she'd", "she'll", "she's", "should", "so", "some", "such", "than", "that", "that's", "the", "their", "theirs", "them", "themselves", "then", "there", "there's", "these", "they", "they'd", "they'll", "they're", "they've", "this", "those", "through", "to", "too", "under", "until", "up", "very", "was", "we", "we'd", "we'll", "we're", "we've", "were", "what", "what's", "when", "when's", "where", "where's", "which", "while", "who", "who's", "whom", "why", "why's", "with", "would", "you", "you'd", "you'll", "you're", "you've", "your", "yours", "yourself", "yourselves" ]

		print("Words BEFORE stopword removal: ", len(unique_words))
		unique_words = [word for word in unique_words if word[0] not in stop_words]
		unique_words = [word for word in unique_words if word[0] not in other_stopwords]
		print("Words AFTER stopword removal: ", len(unique_words))

	print("Words not matching: ", words_not_matching)

	unique_words = np.array(unique_words)

	# getting POS tags for what we have
	if pos_tags == True:
		tagged_words = nltk.pos_tag(unique_words[:,0]) 

		words_for_analysis = []
		desirable_pos = ["NN", "NNS", "NNP", "NNPS", "JJ", "VP", "VB", "VBD", "VBG", "VBN", "VBP", "JJR", "JJS"]

		words_excluded = []

		# only gets the POS that we want
		# we also record the other ones to see what's up
		for i in range(len(unique_words)):
			if tagged_words[i][1] in desirable_pos:
				output = unique_words[i]
				output = np.append(output, tagged_words[i][1])

				words_for_analysis.append(output)
			else:
				output = unique_words[i]
				output = np.append(output, tagged_words[i][1])

				words_excluded.append(output)

	print("INCLUDED: ", len(words_for_analysis), " EXCLUDED: ",len(words_excluded))

	return words_for_analysis, words_excluded



def output_words_for_context(company, word_list):
	with open("%s_words_for_context.txt" % company, "w") as file_name:
		for word in word_list:
			print(word)
			file_name.write(word[0] + " " + str(word[1]) + " " + str(word[2]) + " " + word[3] + "\n")


def main():

	print("Let's see what we've got here...")

	amazon_words = []
	google_words = []

	with open("amazon_timings_for_words.txt", "r") as read_file:
		for line in read_file.readlines():
			amazon_words.append(line.strip("\n"))
	with open("google_timings_for_words.txt", "r") as read_file:
		for line in read_file.readlines():
			google_words.append(line.strip("\n"))


	amazon_words_for_context, amazon_words_excluded = get_words_for_analysis(amazon_words, True, True)
	google_words_for_context, google_words_excluded = get_words_for_analysis(google_words, True, True)

	output_words_for_context("amazon_included", amazon_words_for_context)
	output_words_for_context("amazon_excluded", amazon_words_excluded)
	output_words_for_context("google_included", google_words_for_context)
	output_words_for_context("google_excluded", google_words_excluded)


if __name__ == "__main__":

	main()
