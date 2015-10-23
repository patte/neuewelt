Template.crumb.helpers
  isEditing: ->
    Session.get('editingCrumbId') is @_id

Template.crumb.events
  'click .edit': (evt) ->
    Session.set 'editingCrumbId', @_id
    false

  'click .save': (evt) ->
    md = Session.get('editor-markdown')
    Meteor.call "saveCrumb", @_id, md, (error, id)->
      throwError error if error?
      Session.set 'editingCrumbId', null
    false
