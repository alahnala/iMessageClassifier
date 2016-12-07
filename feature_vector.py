import nltk
import sys
import re
from Unicode import *
from sklearn import preprocessing
from sklearn.neighbors import KNeighborsClassifier
import numpy as np
from process_training import *
from sets import Set


def make_feature_vector(tweets, uni_features, feature_vector, sentiment, labels, invert_index, idf_dict, unigram_scores):
    print("Making feature vector...");
    le = preprocessing.LabelEncoder()
    le.fit(list(corpus))
    for tweet in tweets:
        features = dict.fromkeys(uni_features)

        for token in word_tokenize(tweets[tweet].decode('utf-8')):
            if token in features:
                #this is for the tfidf scheme
                tfidf = invert_index[token][tweet] * idf_dict[token]
                features[token] = unigram_scores[token] * tfidf


        # #abbrev, sl, and conj are my feature choices
        # abbrev = is_abbreviation(word) #want word included with period
        # sl = sentence_len_constaint(i, last_index) #senctence lenght, includes , and ; though
        # num = int(unicode(L, 'utf-8').isnumeric()) #if is number
        # features.append(sl)    

        feature_vector.append(features)
        del features
        labels.append(sentiment[tweet])
    print("Feature vector complete");


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
features = list(test_unigrams & NRC_unigrams)

training_vector = []
training_labels = []
make_feature_vector(tweets, features, training_vector, sentiment, training_labels, training_index, idf_dict, unigram_scores)


    





