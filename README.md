We makin' some kewl stuff.

# Mac application

## Requirements

* macOS 10.11 or later
* Python 2 and nltk package
* (Optionally) Xcode 8.1 to compile in Xcode

## Files

Source used for the Mac application are in the `app` directory. The compiled application is in the root directory for the project, called `MessagesSentiments.app`. 

## Running Mac application:

* Option 1: launch compiled app:
  * Double-click on `MessagesSentiments.app`

* Option 2: lauch from Xcode 8.1:
  * Open `app/MessagesTestMac/MessagesTestMac.xcodeproj` in Xcode
  * Set scheme to MessagesTestMac > My Mac (top left corner near Run and Stop buttons)
  * Run

* Set Python Path to the path to Python 2 on the computer.
  * The path can be found by executing `which python` command in Terminal.
  * You also must have `nltk` package installed, as well as the corpus data it uses.

* Open chat database.
  * The sample database is provided in `datasets/chat.db`.
  * Actual iMessage database for the user is located at `~/Libarary/Messages/chat.db`.


# Python classifier

## Requirements

* Python 2 and nltk package

## Files

Source files used for the the evaluation are in the root directory for the project, specifically `feature_vector.py`, `process_training.py` and `parse_train.py`. In addition, the classifier requires a JSON file with messagese, an example of which is found in `datasetes/messages.json` and a labels file, as well as `Sentiment Analysis Dataset.csv` and `unigrams.txt`, both of which are in the root directory for the project.

## Running `feature_vector.py`

* Execute the following command in Terminal: 
```
$ python feature_vector.py messages.json "Sentiment Analysis Dataset.csv" unigrams.txt
```


# Evaluation

## Requirements

* Python 2 and nltk package

## Files

Source file used for the the evaluation is in the root directory for the project, called `get_accuracy.py`. In addition, evaluation requires a predictions file, an example of which is found in `datasetes/labeled_messages.json` and a labels file, an example of which is found in `datasets/xinrui_labels.txt`.

## Running `get_accuracy.py`

* Execute the following command in Terminal: 
```
$ python get_accuracy.py <predictions file> <labels file> 
```

# Datasets

Included in the `datasets` directory are

* `chat.db`, a sample iMessages database that can be used in the Mac application.
* `messages.json`, a sample JSON file of messages created by the Mac application and used by the Python classifier.
* `labeled_messages.json`, a sample JSON file of sentiment labels created by the Python classifier and used by the Mac application.
* `xinrui_labels.txt`, a text file with sentiment labels created by humans, used for the evaluation.
