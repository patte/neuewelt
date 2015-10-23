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

