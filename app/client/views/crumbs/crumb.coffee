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

  'click .scrollToTopOfCrumb': (evt, template) ->
    $(window).scrollTop template.$('.crumb-content').offset().top

  'click .seeLess': (evt, template) ->
    template.$('.crumb-content').readmore('toggle')


Template.crumbContent.onRendered ->
  #add bootstrap class table to tables
  @$('table').addClass('table')
  #init readmore
  @$('.crumb-content').readmore('destroy')
  @$('.crumb-content').readmore
    moreLink: '<a href="#">See more</a>'
    lessLink: '<a href="#">See less</a>'
    collapsedHeight: 215
    afterToggle: (trigger, element, expanded) ->
      id = $(element).attr('id')
      if expanded
        # we use namespaced events to be able to
        # have multiple event handlers and remove them individually
        # http://stackoverflow.com/questions/12270769/unbinding-event-that-has-been-bound-mutliple-times
        $(window).bind "scroll.#{id}", (evt) ->
          manageAffixControls trigger, element, expanded
      else
        $(window).unbind("scroll.#{id}")
      manageAffixControls trigger, element, expanded

Template.crumbContent.onDestroyed ->
  crumbContent = @$('.crumb-content')
  crumbContent.readmore('destroy')
  id = crumbContent.attr('id')
  $(window).unbind("scroll.#{id}")

manageAffixControls = (trigger, element, expanded)->
  expandedCrumb = $(element)
  if expandedCrumb.length > 0
    win = $(window)
    winTop = win.scrollTop()
    winBottom = winTop + win.height()
    elem = expandedCrumb
    elemTop = elem.offset().top
    elemBottom = elemTop + elem.height()
    affixControls = expandedCrumb.find('.affixControls')
    scrollToTopOfCrumb = affixControls.find('.scrollToTopOfCrumb')
    if elemBottom >= winBottom and (elemTop+50) < winBottom
      affixControls.show()
      if elemTop+10 < winTop
        scrollToTopOfCrumb.show()
      else
        scrollToTopOfCrumb.hide()
    else
      affixControls.hide()
