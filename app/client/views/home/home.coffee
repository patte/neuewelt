Template.home.onCreated ->
  @subscribe "posts"

Template.home.helpers
  posts: ->
    if Roles.userIsInRole(Meteor.user(), 'admin')
      Posts.find()
    else
      Posts.find
        published: true

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

