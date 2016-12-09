# Ember-mu-comments
## Installation

* `npm install ember-intl`
* `npm install ember-modal-dialog`
* `npm install ember-tether`
* `npm install ember-cli-coffeescript`
* `npm install ember-mu-comments`


## Basic usage
### How to display a list of comments
```javascript
{{display-comments about=about user=user isDisplayed=isDisplayed loadingPlaceholder=loadingPlaceholder}}
and
{{display-notifications user=user loadingPlaceholder=loadingPlaceholder handleClick="handleClick"}}
```

"handleClick" needs to be handled by the platform, it is triggered every time a user clicks on a cell of the notifications table (except the 
one to switch status).
