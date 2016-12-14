We makin' some kewl stuff.

Running `feature_vector.py`:

```
python feature_vector.py messages.json "Sentiment Analysis Dataset.csv" unigrams.txt
```

Running MessagesTestMac:

* Go to `/Users/your-username/Library/Messages`
* Copy `chat.db` to Desktop
* Open `MessagesTestMac.xcodeproj` in Xcode
* Set scheme to MessagesTestMac > My Mac (top left corner near Run and Stop buttons)
* Run
* If unable to open the database, go to line 202 of MainSplitViewController.swift and comment out `config.readonly = true`. Run the app and it should work. Then uncomment `config.readonly = true` so at to avoid accidentally modifying the database.

