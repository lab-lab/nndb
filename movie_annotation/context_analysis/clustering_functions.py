from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler
import matplotlib.pyplot as plt
import numpy as np
from sklearn import cluster
from sklearn.metrics import silhouette_samples, silhouette_score
from sklearn.preprocessing import MinMaxScaler

# What number of components did Gallant use for the movie annotations?
# need to see how they've used PCA on their data
def do_PCA(word_vectors):
	print(word_vectors.shape)
#	x = StandardScaler().fit_transform(x)

	pca = PCA(n_components=100)
	pca.fit(word_vectors)
#	components = pca.fit(word_vectors)
#
#	print(sum(pca.explained_variance_[:10]))
	plt.plot(np.cumsum(pca.explained_variance_ratio_))
	plt.xlabel('number of components')
	plt.ylabel('cumulative explained variance')
	#plt.show()


def ClusterIndices(clustNum, labels_array):
	return np.where(labels_array == clustNum)[0]

# spits out the cluster labels computed
def output_cluster(name, cluster_labs):
	with open('500days_words_' + name + ".txt","w") as output:
		for lab in cluster_labs:
			output.write(lab + '\n')
#####################################
##### Agglomeration Clustering ######
#####################################
def describe_agglom_components(model, cluster_vectors, all_vectors):

	print("Clustering method ", cluster_vectors["linkage"])
	clusters = []
	for clust in cluster_vectors["clusters"]:
		#print("--------------------")
		#print("Cluster" + str(clust["name"]))
		cluster_words = []
		for component in clust["components"]:
			cluster_words.append(model.most_similar(positive=[all_vectors[component]], topn=1)[0])
                        #print(model.most_similar(positive=[all_vectors[component]], topn=1))
		cluster_words = [wd[0] for wd in cluster_words]
                #output_cluster(str(clust["name"]), cluster_words)
		clusters.append(cluster_words)

	return clusters

def cluster_agglom(all_vectors, model):

	agglom_clusters = []

	#for linkage in ('ward', 'average', 'complete', 'single'):
	linkage= 'ward'
	clustering = cluster.AgglomerativeClustering(linkage=linkage, n_clusters=35).fit(all_vectors)
	temp_labels = set(clustering.labels_)
	temp_clusters = []
                #print("---------")
                #print(linkage)
	for clust in temp_labels:
		temp_clusters.append({"name": clust, "components": ClusterIndices(clust, clustering.labels_)})

	agglom_clusters.append({"linkage": linkage, "clusters": temp_clusters})

	clusters = describe_agglom_components(model, agglom_clusters[0], all_vectors)
#       for clust in clusters:
#               print(clust)
#               print("\n")
	return clusters



#################################
###### KMEANS Clustering ########
#################################

def cluster_kmeans(all_vectors, model):
# good values seem to be k=26 or k= 23 for the transcript
# k=35 for GC labels
# k=35 for AWS labels as well
# k=38 for ALL labels
# k=36 for all words - need to experiment more on the number of clusters 

# need to play around with random_state - what's the most optimal?
# initial value: 10

	kmeans = cluster.KMeans(n_clusters=50, random_state=10).fit(all_vectors)
        #kmeans = cluster.MiniBatchKMeans(n_clusters=26).fit(all_vectors)
	kmeans_cluster_labels = set(kmeans.labels_)
	kmeans_clusters = []

# for each cluster, returns the index of each component in the big list of components' vectors
	for clust in kmeans_cluster_labels:
		kmeans_clusters.append({"name": clust, "components": ClusterIndices(clust, kmeans.labels_)})
	cluster_centroids = []
	for clust in kmeans_clusters:
		print("--------------------")
		print("Cluster " + str(clust["name"]))
		cluster_output = []
		cluster_vectors = np.empty((len(clust["components"]), 300))
		i = 0
		for component in clust["components"]:
                        # uses the component as an index in all_vectors to return the 300D vector and get a label from w2v
			cluster_output.append(model.most_similar(positive=[all_vectors[component]], topn=1)[0])
			cluster_vectors[i] = all_vectors[component]
			i += 1

#		cluster_centroid = np.mean(cluster_vectors, axis=0)

        ####################################
        ############# OUTPUT ###############
        ### cluster words and wordclouds ###
        ####################################
#               cluster_centroids.append([clust["name"], model.most_similar(positive=[cluster_centroid], topn=1)[0]])

#               cluster_texted = ""
#               for wd in cluster_output:
#                       cluster_texted = cluster_texted + " " + wd[0]

		cluster_output = [wd[0] for wd in cluster_output]

#               cloud_words(cluster_texted, "cluster" + str(clust["name"]))
		output_cluster(str(clust["name"]), cluster_output)

#       with open("clusters_centroids.txt", "w") as f:
#               for item in cluster_centroids:
#                       f.write(str(item[0]) + " " + str(item[1]) + '\n')



def estimate_elbow_cluster_num(data):
	mms = MinMaxScaler()
	mms.fit(data)
	data_transformed = mms.transform(data)

	Sum_of_squared_distances = []
	K = range(5, 50)
	for k in K:
#               km = cluster.KMeans(n_clusters=k, random_state=20).fit(data_transformed)
		km = cluster.MiniBatchKMeans(n_clusters=k, random_state=10).fit(data_transformed)
		Sum_of_squared_distances.append(km.inertia_)

	plt.plot(K, Sum_of_squared_distances, 'bx-')
	plt.xlabel('k')
	plt.ylabel('Sum_of_squared_distances')
	plt.title('Elbow Method For Optimal k')
	plt.show()
	#plt.savefig("w2v_elbow_estimate.png")

def estimate_silhou_cluster_num(data, n_clusters):

	fig, (ax1) = plt.subplots(1, 1)
	fig.set_size_inches(18, 7)

	ax1.set_xlim([-0.1, 1])
	ax1.set_ylim([0, len(data) + (n_clusters + 1) * 10])
	clusterer = cluster.KMeans(n_clusters=n_clusters, random_state=10)
	cluster_labels = clusterer.fit_predict(data)
	silhouette_avg = silhouette_score(data, cluster_labels)
	print("----------------------")
	print("For n_clusters =", n_clusters,
		"The average silhouette_score is :", silhouette_avg)
	sample_silhouette_values = silhouette_samples(data, cluster_labels)

	y_lower = 10
	for i in range(n_clusters):
                # Aggregate the silhouette scores for samples belonging to
                # cluster i, and sort them
		ith_cluster_silhouette_values = \
			sample_silhouette_values[cluster_labels == i]

		ith_cluster_silhouette_values.sort()

		size_cluster_i = ith_cluster_silhouette_values.shape[0]
		y_upper = y_lower + size_cluster_i

		color = cm.nipy_spectral(float(i) / n_clusters)
		ax1.fill_betweenx(np.arange(y_lower, y_upper),
				0, ith_cluster_silhouette_values,
				facecolor=color, edgecolor=color, alpha=0.7)

                # Label the silhouette plots with their cluster numbers at the middle
		ax1.text(-0.05, y_lower + 0.5 * size_cluster_i, str(i))

                # Compute the new y_lower for next plot
		y_lower = y_upper + 10  # 10 for the 0 samples

		ax1.set_title("The silhouette plot for the various clusters.")
		ax1.set_xlabel("The silhouette coefficient values")
		ax1.set_ylabel("Cluster label")

                # The vertical line for average silhouette score of all the values
		ax1.axvline(x=silhouette_avg, color="red", linestyle="--")

		ax1.set_yticks([])  # Clear the yaxis labels / ticks
		ax1.set_xticks([-0.1, 0, 0.2, 0.4, 0.6, 0.8, 1])

	plt.show()



