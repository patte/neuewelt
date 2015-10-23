Template.crumb.helpers
  isEditing: ->
    Session.get('editingCrumbId') is @_id

  content: ->
    @content or ""

Template.crumb.events
  'click .edit': (evt) ->
    Session.set 'editingCrumbId', @_id
    false

  'click .save': (evt) ->
    md = Session.get('editor-markdown')
    if !md? #no changes
      Session.set 'editingCrumbId', null
      return
    Meteor.call "saveCrumb", @_id, md, (error, id)->
      throwError error if error?
      Session.set 'editingCrumbId', null
    false

  'click .cancel': (evt) ->
    Session.set 'editingCrumbId', null
    false

Template.crumbContent.onRendered ->
  @$('.crumb-content').readmore('destroy')
  @$('.crumb-content').readmore()

Template.crumbContent.onDestroyed ->
  @$('.crumb-content').readmore('destroy')
