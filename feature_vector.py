import nltk
import sys
import re
from Unicode import *
from sklearn import preprocessing
from sklearn.neighbors import KNeighborsClassifier
import numpy as np
from process_training import *


def make_feature_vector(items, vocab, feature_vector, labels):
    le = preprocessing.LabelEncoder()
    le.fit(list(corpus))
    for i in range(len(items) - 1):
        for j, token in enumerate(nltk.word_tokenize(items[i])):
            features = [0] * 4

            #Feature 1. the value of the token
            tok = token[:-2]
            val = le.transform([tok])[0]
            features[0] = val

            #Feature 2. is the token all uppercase?
            up = int(tok.isupper())
            features[1] = up

            #Feature 3. does the token start with capital?
            cap = int(tok[0].isupper())
            features[2] = cap

            # Feature 4. is the word an emoji?
            features[3] = unicode(val) in unicode_chars
            print features[3]

            #Feature 6. is labeled positive by saifmohammad
            eecsword = isEECSword(tok.lower())
            features[4] = eecsword


            # #abbrev, sl, and conj are my feature choices
            # abbrev = is_abbreviation(word) #want word included with period
            # sl = sentence_len_constaint(i, last_index) #senctence lenght, includes , and ; though
            # num = int(unicode(L, 'utf-8').isnumeric()) #if is number
            # features.append(sl)    

            feature_vector.append(features)
            del features
            labels.append(token[-2:])


sentiment, tweets = get_training_data2()
corpus = make_corpus(tweets)
unigram_scores = get_unigram_scores(corpus)

training_index = {}
index_tweets(tweets, training_index)


df_dict = {}
make_df_dict(tweets, training_index, df_dict)

idf_dict = {}
make_idf_dict(tweets, training_index, df_dict, idf_dict)





#print len(training)       





