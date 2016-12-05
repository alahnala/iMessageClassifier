import nltk
import sys
import re
from dicts import *
from sklearn import preprocessing
from sklearn.neighbors import KNeighborsClassifier
import numpy as np

def make_feature_vector(items, vocab, feature_vector, labels):
    le = preprocessing.LabelEncoder()
    le.fit(list(corpus))
    for i in range(len(items) - 1):
        for j, token in enumerate(items[i].split()):
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


            
