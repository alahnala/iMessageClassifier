import csv, sys, json, nltk

def read_input(filename="messages.json"):
	messages = {}
	senders = {}
	message_corpus = {}
	conversation_file = open(filename, 'r')
	conversation_content = conversation_file.read()
	json_conversation = json.loads(conversation_content)
	for message_object in json_conversation: 
		if message_object['isFromMe'] == "false": 
			sender = message_object['handleID']
		else: 
			sender = 0

		message_id = message_object['rowID']
		message_text = message_object['text']

		messages[message_id] = message_text.encode('utf-8')
		senders[message_id] = sender 

		for word in nltk.word_tokenize(message_text): 
			if word not in message_corpus: 
				message_corpus[word] = 0
			message_corpus[word] += 1
	return messages, senders, message_corpus

# def get_messages(): 
# 	print messages
# 	return messages

# def get_senders(): 
# 	print senders
# 	return senders

# def get_corpus(): 
# 	print message_corpus
# 	return message_corpus

def main():
	filename = sys.argv[1]
	read_input(filename)

if __name__ == '__main__':
	main()

