import csv
import sys

def read_csv():
	infile = sys.argv[1]
	with open(infile, 'rb') as f:
		reader = csv.reader(f)
		mydict = dict((rows[0],rows[1:]) for rows in reader)

