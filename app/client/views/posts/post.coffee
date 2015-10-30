# we catch the keydown event of contenteditable in
# the Template.post.events map
Template.postTitle.onRendered ->
  if Roles.userIsInRole Meteor.userId(), 'admin'
    @$('.page-header h1').attr('contenteditable', 'true')


Template.post.onCreated ->
  @subscribe("crumbsForPost", @data._id)

Template.post.helpers
  post: ->
    @

  crumbs: ->
    Crumbs.find
      postId: @_id
    ,
      sort: { index: 1 }

Template.post.events
  'submit #createCrumb': (evt) ->
    evt.preventDefault()
    Meteor.call "createCrumb", @_id, (error, _id)->
      throwError error if error?
      Session.set 'editingCrumbId', _id
    false

  'keydown h1[contenteditable]': (evt) ->
    #13 -> return key
    if evt.keyCode is 13
      title = evt.target.innerText
      Meteor.call 'changePostTitle', @_id, title, (error, slug) ->
        throwError error if error?
        Router.go 'post',
          slug: slug
        ,
          replaceState: true
      return false
    return true
