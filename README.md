# Ember-mu-comments
## Installation

* `npm install ember-intl`
* `npm install ember-modal-dialog`
* `npm install ember-tether`
* `npm install ember-cli-coffeescript`
* `npm install ember-mu-comments`

## Setup
Back-end : git@git.tenforce.com:mu-semtech/mu-comments.git
If you provide it yourself, the front-end do not provide information about the Author, we used a cookie for that.
```

## Basic usage
### How to display a list of comments
```javascript
{{display-comments about=aboutId}}
```
### Controller :  
The controller only needs to provide the "About", which is the target of the comment. 
If it changes, as long as the controller sees the change, the addon should notice the modification and refresh the list.

###Note :
The list is not refreshed unless you switch from one "About" to another. This is to prevent too many calls as we do not really need a chatbox.
