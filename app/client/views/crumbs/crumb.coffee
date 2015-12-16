Template.crumb.helpers
  isEditing: ->
    Session.get('editingCrumbId') is @_id

  content: ->
    @content or ""

Template.crumb.events
  # intercept anchor clicks and
  # and open files in a new window
  'click a': (evt) ->
    href = evt.target.href
    if href.indexOf("http") > -1 || href.indexOf("files") > -1
      evt.preventDefault()
      window.open evt.target.href, "_blank"
      return false
    true

  'click .edit': (evt) ->
    if cancelCrumbEditing()
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
    cancelCrumbEditing()
    false

  'click .remove': (evt) ->
    if confirm("are you sure?")
      Meteor.call "removeCrumb", @_id, (error, id)->
        throwError error if error?
    false

  'click .moveUp': (evt) ->
    evt.preventDefault()
    evt.stopPropagation()
    Meteor.call "decCrumbIndex", @_id, (error, id)->
      throwError error if error?
    false

  'click .moveDown': (evt) ->
    evt.preventDefault()
    evt.stopPropagation()
    Meteor.call "incCrumbIndex", @_id, (error, id)->
      throwError error if error?
    false

  'click .scrollToTopOfCrumb': (evt, template) ->
    $(window).scrollTop template.$('.crumb-content').offset().top

  'click .seeLess': (evt, template) ->
    template.$('.crumb-content').readmore('toggle')

  #expand a crumb when clicking on it's content
  "click .crumb-content": (evt, template) ->
    if getSelection().toString().length is 0
      template.$('.crumb-content').readmore('toggle')


@cancelCrumbEditing = ->
  Tracker.nonreactive ->
    editingCrumbId = Session.get 'editingCrumbId'
    if editingCrumbId?
      crumb = Crumbs.findOne editingCrumbId
      md = Session.get('editor-markdown') #null if unchanged
      if md? and crumb.content.valueOf() isnt md.valueOf() #content changed
        $(window).scrollTop $("##{crumb._id}.crumb").offset().top
        if !confirm("You edited the content of this crumb. Are you sure you don't want to save it?")
          return false
    Session.set 'editingCrumbId', null
    return true


Template.crumbContent.onRendered ->
  #add bootstrap class table to tables
  @$('table').addClass('table')
  #init readmore
  @$('.crumb-content').readmore('destroy')
  @$('.crumb-content').readmore
    # moreLink: '<a href="#"><i class="fa fa-lg fa-expand"></i></a>'
    moreLink: '<a class="more-or-less" href="#"><i class="fa fa-2x fa-ellipsis-h"></i></a>'
    lessLink: '<a class="more-or-less" href="#"><i class="fa fa-lg fa-compress"></i></a>'
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
