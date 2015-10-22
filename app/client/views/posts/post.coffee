Template.post.onCreated ->
  @subscribe("crumbsForPost", @data._id)

Template.post.helpers
  post: ->
    @

  crumbs: ->
    Crumbs.find
      postId: @_id

  #this crumb
  crumbIsEditing: ->
    Session.get('editingCrumbId') is @_id

Template.post.events
  'submit #createCrumb': (evt) ->
    evt.preventDefault()
    Meteor.call "createCrumb", @_id, (error, _id)->
      throwError error if error?
      Session.set 'editingCrumbId', _id
    false

  'click .editCrumb': (evt) ->
    Session.set 'editor-markdown', @content
    Session.set 'editingCrumbId', @_id
    false

  'click .saveCrumb': (evt) ->
    md = Session.get('editor-markdown')
    Meteor.call "saveCrumb", @_id, md, (error, id)->
      throwError error if error?
      Session.set 'editingCrumbId', null
      false

