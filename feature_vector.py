import nltk
import sys
import re
from Unicode import *
from sklearn import preprocessing
from sklearn.neighbors import KNeighborsClassifier
import numpy as np
from process_training import *
from sets import Set


def make_feature_vector(tweets, uni_features, feature_vector, sentiment, labels, invert_index, idf_dict, unigram_scores, state):
    print "Making", state, "feature vector..."

    for tweet in tweets:
        features = dict.fromkeys(uni_features, 0)

        for token in word_tokenize(tweets[tweet].decode('utf-8')):
            if token in features:
                #this is for the tfidf scheme
                tfidf = invert_index[token][tweet] * idf_dict[token]
                if token in unigram_scores:
                    features[token] = unigram_scores[token] * tfidf                  

        feature_vector.append(features.values())
        del features
        if state == "training":
            labels.append(sentiment[tweet])
    #print feature_vector
    print state, "feature vector complete."


sentiment, tweets = get_training_data2()
corpus = make_corpus(tweets)
unigram_scores = get_unigram_scores(corpus)



training_index = {}
index_tweets(tweets, training_index)


df_dict = {}
make_df_dict(tweets, training_index, df_dict)

idf_dict = {}
make_idf_dict(tweets, training_index, df_dict, idf_dict)

#make set intersection for feature vector
test_unigrams = Set(corpus.keys())
NRC_unigrams = Set(unigram_scores.keys())
unicode_unigrams = Set(unicode_scores.keys())

features = list(test_unigrams & NRC_unigrams)

# features = list(test_unigrams & NRC_unigrams & unicode_unigrams)
# print "featutes with unicode added", features

training_vector = []
training_labels = []

make_feature_vector(tweets, features, training_vector, sentiment, training_labels, training_index, idf_dict, unigram_scores, "training")


test_vector = []
tmp = []
make_feature_vector(messages, features, test_vector, sentiment, tmp, training_index, idf_dict, unigram_scores, "testing")

def mydist(x, y, **kwargs):
    return np.sum((x-y)**kwargs["power"])


X = np.array(training_vector)
Y = np.array(labels)
nbrs = KNeighborsClassifier(n_neighbors=1, algorithm='ball_tree',metric=mydist, metric_params={"power": 2})
nbrs.fit(X, Y)
Z = np.array(test_vector)
dists, inds = nbrs.kneighbors(Z)

f = open('labeled_messages.txt','w')
j = 0
for message in messages:
    line += messages[message] + ' ' + labels[inds[j]]
    line += '\n'
    j+=1
    f.write(line)



#make feature vector for 





    





