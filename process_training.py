from nltk import word_tokenize
import csv
import sys
import math
#training data format
#ItemID,Sentiment,SentimentSource,SentimentText


def get_training_data():
	# source_file = open(NNSRC, 'rb')
	# header = source_file.readline()
	# source_file.seek(len(header))  # reset read buffer

	print("Collection training data...");
	cases = {};
	infile = "Sentiment Analysis Dataset.csv"
	with open(infile, 'rb') as f:
		header = f.readline()
		headers = [h.strip('.') for h in header.split(',')]
		print headers
		reader = csv.reader(f)
		Sentiment = [(row['\xef\xbb\xbfItemID'], row['Sentiment']) for row in csv.DictReader(infile, fieldnames=headers, delimiter = ',')]
		SentimentText = [(row['\xef\xbb\xbfItemID'], row['SentimentText\r\n']) for row in csv.DictReader(infile, fieldnames=headers)]
	print("Training data collected.");
	return Sentiment, SentimentText


def get_training_data2():
	# source_file = open(NNSRC, 'rb')
	# header = source_file.readline()
	# source_file.seek(len(header))  # reset read buffer
	Sentiment = {}
	SentimentText = {}
	print("Collection training data...");
	source_file = open("Sentiment Analysis Dataset.csv", 'rb')
	header = source_file.readline()
	source_file.seek(len(header))  # reset read buffer

	headers = [h.strip('.') for h in header.split(',')]

	i = 0
	for line in csv.DictReader(source_file, fieldnames=headers, delimiter = ','):
		ItemID = int(line['\xef\xbb\xbfItemID'])
		Sentiment[ItemID] = int(line['Sentiment'])
		SentimentText[ItemID] = line['SentimentText\r\n']
		i += 1
		if i == 500: 
			break
	print("Training data collected.");
	return Sentiment, SentimentText

def get_unigram_scores(corpus):
	print("Getting unigram scores..");
	unigram_scores = {}
	source_file = open("unigrams.txt", 'rb')
	for line in source_file:
		if line[0] != '@':
			unigram_scores[line.split()[0]] = float(line.split()[1])
	return unigram_scores
	print("unigram_scores dictionary created");


def add_to_corpus(corpus, tokens):
	for token in tokens:
		if corpus.has_key(token.lower()):
			corpus[token.lower()] += 1
		else:
			corpus[token.lower()] = 1

def make_corpus(SentimentText):
	print("Creating corpus...");
	corpus = {}
	for text in SentimentText.values():
		tokens = word_tokenize(text.decode('utf-8')) #tokenize sentence
		add_to_corpus(corpus, tokens)
	print("Corpus created.");
	return corpus

def indexDocument(tweet_id, tweet, invert_index):
	for token in word_tokenize(tweet.decode('utf-8')):
		if invert_index.has_key(token.lower()):
			if invert_index[token.lower()].has_key(tweet_id):
				invert_index[token.lower()][tweet_id] = invert_index[token.lower()][tweet_id] + 1
			else:
				invert_index[token.lower()][tweet_id] = 1
		else:
			invert_index[token.lower()] = {tweet_id: 1}

def index_tweets(tweets, invert_index):
	print("Indexing tweets...");
	for ItemID in tweets:
		#doc_id, doc_content, doc_scheme, q_scheme, invert_index
		indexDocument(ItemID, tweets[ItemID], invert_index)
	print("Tweets indexed...");

def make_df_dict(tweets, invert_index, df_dict):
	print("making df dict...");
	for token in invert_index:
		df_dict[token] = len(invert_index[token])
	print("df dict created");

def make_idf_dict(tweets, invert_index, df_dict, idf_dict):
	print("making idf dict...");
	for term in invert_index:
		idf = math.log10(len(tweets) / df_dict[term] + 1)
		idf_dict[term] = idf
	print("idf dict created");































