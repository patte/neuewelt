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

  'click .remove': (evt) ->
    if confirm("are you sure?")
      Meteor.call "removeCrumb", @_id, (error, id)->
        throwError error if error?
    false


Template.crumbContent.onRendered ->
  #add bootstrap class table to tables
  @$('table').addClass('table')
  #init readmore
  @$('.crumb-content').readmore('destroy')
  @$('.crumb-content').readmore
    moreLink: '<a href="#">See more</a>'
    lessLink: '<a href="#">See less</a>'
    collapsedHeight: 215

Template.crumbContent.onDestroyed ->
  @$('.crumb-content').readmore('destroy')
