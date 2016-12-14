import csv, sys, json

filename = sys.argv[1]
answers = open(sys.argv[2], 'r').read().split("\n") 

conversation_file = open(filename, 'r')
conversation_content = conversation_file.read()
json_conversation = json.loads(conversation_content)

i = 0

numerator = 0 
denominator = 0 

for label in json_conversation:
	denominator += 1 
	prediction = label['sentiment']
	if prediction == answers[i].replace(" ", ""):
		numerator += 1
	i += 1

print "Accuracy: " + str(float(numerator)/denominator)

