# FicFeed
An app to browse & track tags on AO3.

![](http://i.imgur.com/pmkdV0N.jpg)
![](http://i.imgur.com/CMryoag.jpg)
![](http://i.imgur.com/ztrWfiG.jpg)
![](http://i.imgur.com/VJYMPoZ.jpg)
![](http://i.imgur.com/71vJPpM.jpg)

## Overview
FicFeed has two components: the front-end app and the notification server.
- App:
	- Written in Swift.
	- Uses CocoaPods.
	- Depends on [Firebase](https://firebase.google.com/) and [MWFeedParser](https://github.com/mwaterfall/MWFeedParser).
- Server:
	- Written in Python.
	- Depends on [PyFCM](https://github.com/olucurious/PyFCM) and [feedparser](https://pypi.python.org/pypi/feedparser).

## What does it do?
- Browse ~400 fandom tags and view the 25 newest works in each (pulled from each tag’s RSS feed).
- Read works in the app using a WKWebView.
- Track/untrack tags to receive notifications about new works.
	- This is courtesy of the notification server, which iterates through all the tags, checking their RSS feeds for anything new, and sends notifications to topics corresponding to each tag. All this is executed regularly on a fixed schedule (via a cron job).

## Notes
You may notice this app doesn't appear in the App Store. That's because it isn't published: it doesn't work with some particular Internet protocol. I was too busy with other things to fix that issue (though it should still work), and this has just been sitting around on my computer for a while until I decided to upload it. Feel free to do whatever you like with it!

Also, the API key in the notification server, as well as `GoogleServices-Info.plist` have been omitted. Additionally, text files that the notification server uses have been omitted for practicality (or lack thereof).
