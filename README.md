We makin' some kewl stuff.

Running `feature_vector.py`:
```
python feature_vector.py messages.json "Sentiment Analysis Dataset.csv" unigrams.txt
```

Running Mac application:

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


Running `get_accuracy.py`:
* Run the following command: 
```
$ python get_accuracy.py <predictions file> <labels file> 
```
