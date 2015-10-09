Template.home.onCreated ->
  @subscribe "posts"

Template.home.helpers
  posts: ->
    Posts.find()
    
Template.home.events
  'submit #createPost': (evt) ->
    evt.preventDefault()
    title = evt.target.title.value
    Meteor.call "createPost", title, (error, id)->
      throwError error if error?
      Router.go 'post',
        id: id
    evt.target.title.value = ""
    evt.target.title.blur()


    
