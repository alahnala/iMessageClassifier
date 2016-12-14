import nltk
import sys
import re
import json
#from Unicode import *
from sklearn import preprocessing
from sklearn.neighbors import KNeighborsClassifier
import numpy as np
from process_training import *
from sets import Set
from parse_train import *


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


messages_filename = sys.argv[1]
sentiment_analysis_dataset_filename = sys.argv[2]
unigrams_filename = sys.argv[3]

sentiment, tweets = get_training_data2(sentiment_analysis_dataset_filename)
corpus = make_corpus(tweets)
unigram_scores = get_unigram_scores(corpus, unigrams_filename)



training_index = {}
index_tweets(tweets, training_index)


df_dict = {}
make_df_dict(tweets, training_index, df_dict)

idf_dict = {}
make_idf_dict(tweets, training_index, df_dict, idf_dict)

#iMessage corpus
messages, senders, message_corpus = read_input(messages_filename)
test_index = {}
index_tweets(messages, test_index)


test_df_dict = {}
make_df_dict(tweets, test_index, test_df_dict)

test_idf_dict = {}
make_idf_dict(tweets, test_index, test_df_dict, test_idf_dict)


#make set intersection for feature vector
test_unigrams = Set(corpus.keys())
NRC_unigrams = Set(unigram_scores.keys())

#unicode_unigrams = Set(unicode_scores.keys())


features = list(test_unigrams & NRC_unigrams & Set(message_corpus.keys()))

# features = list(test_unigrams & NRC_unigrams & unicode_unigrams)
# print "featutes with unicode added", features

training_vector = []
training_labels = []

make_feature_vector(tweets, features, training_vector, sentiment, training_labels, training_index, idf_dict, unigram_scores, "training")


test_vector = []
tmp = []
make_feature_vector(messages, features, test_vector, sentiment, tmp, test_index, test_idf_dict, unigram_scores, "testing")

def mydist(x, y, **kwargs):
    return np.sum((x-y)**kwargs["power"])


X = np.array(training_vector)
Y = np.array(training_labels)
nbrs = KNeighborsClassifier(n_neighbors=5, algorithm='ball_tree',metric=mydist, metric_params={"power": 2})
nbrs.fit(X, Y)
Z = np.array(test_vector)
dists, inds = nbrs.kneighbors(Z)


text_file = open('labeled_messages.txt','w')
json_file = open('labeled_messages.json','w')
j = 0
output_data = []
for message in messages:
    output_message = {}
    output_message["rowid"] = message
    line = ""
    sum = 0
    for i, x in enumerate(inds[j]):
        mcand = 0
        if training_labels[x] == 0:
            mcand = -1
        else:
            mcand = 1
        if float(dists[j][i]) == 0:
            sum += mcand*(1/.0000000001)
        else:
            sum += mcand*(1/float(dists[j][i]))
    norm = sum
    print norm

    if norm >= -100:
        sentiment = "Positive"
    elif norm <= -400:
        sentiment = "Negative"
    else:
        sentiment = "Neutral"
    output_message["sentiment"] = sentiment
    line += messages[message] + ' ' + sentiment
    line += '\n'
    j+=1
    text_file.write(line)
    output_data.append(output_message)

json_file.write(json.dumps(output_data))