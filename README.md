# README #

This solution parses a chat message string and returns a JSON string containing information about its contents.

1. @mentions
2. Emoticons
3. Links, in format: {"url":<urlString>, "title": <title>}, where "title" for domain twitter.com is in format: "<userHandle> / <tweet text>" and for all other domains is the HTML document title.

* Version 1.0

### How do I get set up? ###

* pod install