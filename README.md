# README #

### What is it? ###
This solution parses a chat message string and returns a JSON containing information about its contents.

1. @mentions
2. Emoticons (and word between round brackets)
3. Links, in format: `{"url":<urlString>, "title": <title>}`, where `title` for domain twitter.com is in format: `<userHandle> / <tweet text>` and for all other domains is the HTML document title.

* Version 1.0

### How do I get set up? ###

* pod install

### Example ###
for input:
```
"@bob (awesome) @john (success) such a cool feature; https://twitter.com/jdorfman/status/430511497475670016 https://example.com/"
```

result should be:
```
{
  "emoticons" : [
    "awesome",
    "success"
  ],
  "mentions" : [
    "bob",
    "john"
  ],
  "links" : [
    {
      "url" : "https://twitter.com/jdorfman/status/430511497475670016",
      "title" : "Twitter / jdorfman: Sweet"
    },
    {
      "url" : "https://example.com/"
    }
  ]
}
```
### Design choices ###
* Dependency Inversion for testability
* Promises for declarative async
