# Mu-comments

## Installation

* `npm install ember-intl`
* `npm install ember-modal-dialog`
* `npm install ember-tether`
* `npm install ember-mu-comments`

## Setup
Your back-end needs to get Author information and give it to Ember. You can no longer provide the Author using the template.
```

## Basic usage
### How to display a list of comments
```javascript
{{display-comments author=authorId about=aboutId refreshComments="refreshComments"}}
```
### Controller :  
The controller needs to set both "author" and "about" variables and pass them in the template
    
### Route :
```javascript
  actions:
    refreshComments: ->
      this.refresh()
```
### Adapter
```javascript
`import DS from "ember-data";`
  
  Comment =  DS.JSONAPIAdapter.extend
    host: null
    namespace: null
    init: ->
      this._super();
      this.set('host','http://localhost:8080')
  
`export default Comment`
```
### Basic style : The list of comments will be displayed below the button #showComments
```javascript
button#showComments {
position: absolute;
top: 10px;
right: 10px;
}

.listcomments
{
  border: 1px groove black;
  background-color: #5bc0de;

  .newButton
  {
    position: absolute;
    right: 10px;
    margin-bottom: 10px;
  }
  .newcomment
  {
    margin-top: 10px;
    margin-bottom: 30px;
    
    .content
    {
      margin-right: 5px;
      margin-left: 5px;
    }
  }
  .displaycomment
  {
    margin-top: 20px;
    margin-bottom: 20px;
    
    .buttons
    {
      position: relative;
      left: 115px;
    }
    .author
    {
      position:absolute;
    }
    .date
    {
      position: absolute;
      right: 10px;
      margin-bottom:15px;
    }
    .displayText
    {
      margin-right: 5px;
      margin-left: 5px;
    }
}
```
