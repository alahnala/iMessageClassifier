import csv
import pprint

unicode_scores = {}
with open('EmojiRanking/Emoji_Sentiment_Data_v1.0.csv', 'rb') as csvfile:
	spamreader = csv.reader(csvfile, delimiter=',', quotechar='|')
	for row in spamreader:
		emoji = row[0].decode('utf-8')
		score = row[3]
		unicode_scores[emoji] = score