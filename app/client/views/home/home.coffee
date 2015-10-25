Template.home.onCreated ->
  @subscribe "posts"

Template.home.helpers
  posts: ->
    if Roles.userIsInRole(Meteor.user(), 'admin')
      Posts.find {},
        sort: {index: 1}
    else
      Posts.find
        published: true
      ,
        sort: {index: 1}

Template.home.events
  'submit #createPost': (evt) ->
    evt.preventDefault()
    title = evt.target.title.value
    Meteor.call "createPost", title, (error, slug)->
      throwError error if error?
      Router.go 'post',
        slug: slug
    evt.target.title.value = ""
    evt.target.title.blur()
    false

  'click .togglePublish': (evt) ->
    evt.preventDefault()
    evt.stopPropagation()
    Meteor.call "togglePublishOfPost", @_id, (error)->
      throwError error if error?
    false

  'click .moveUp': (evt) ->
    evt.preventDefault()
    evt.stopPropagation()
    Meteor.call "decPostIndex", @_id, (error)->
      throwError error if error?
    false

  'click .moveDown': (evt) ->
    evt.preventDefault()
    evt.stopPropagation()
    Meteor.call "incPostIndex", @_id, (error)->
      throwError error if error?
    false

  'click .remove': (evt) ->
    if confirm("are you sure?")
      Meteor.call "removePost", @_id, (error)->
        throwError error if error?
    false
