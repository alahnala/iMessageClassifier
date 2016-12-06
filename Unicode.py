import csv
import codecs
import pprint

class Unicode:
	def __init__(self, data):
		self.emoji_dict = {
			"emoji": data[0],
			"codepoint": data[1],
			"occurences": data[2],
			"position": data[3],
			"negative": data[4],
			"neutral": data[5],
			"positive": data[6],
			"name": data[7],
			"block": data[8]
		}

	def print_data(self):
		pprint.pprint(self.emoji_dict)

	def at(self, key):
		try:
			return self.emoji_dict[key]
		except KeyError:
			print("Wrong key doe.")
			exit(1)

unicode_data = []
unicode_chars = set()
with open('EmojiRanking/Emoji_Sentiment_Data_v1.0.csv', 'rb') as csvfile:
	spamreader = csv.reader(csvfile, delimiter=',', quotechar='|')
	for row in spamreader:
		u = Unicode(row)
		unicode_data.append(u)
		unicode_chars.add(u.at("emoji"))
unicode_data = unicode_data[1:]