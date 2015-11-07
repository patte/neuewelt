Template.home.onCreated ->
  @subscribe "posts"

firstHit = true
Template.home.onRendered ->
  document.title = "neue Welt"
  if firstHit
    firstHit = false
  else
    $('.drop').click()

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
  'click .drop': (evt) ->
    #$('.tint').toggleClass('tint-open')
    $('.projects').collapse('toggle')
    drop = $('.drop i')
    if drop.getRotationDegrees() > 0
      $(".drop i").animateRotate null, 360, 500, "swing"
    else
      $(".drop i").animateRotate null, 180, 500, "swing"

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
