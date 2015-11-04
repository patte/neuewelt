dropAreaView = null
Template.files.onRendered ->
  $(window).on 'dragover', (evt) ->
    if !dropAreaView?
      dropAreaView = Blaze.render Template.fullscreenDropArea, document.body
    return

Template.files.onDestroyed ->
  $(window).off 'dragover'

Template.files.helpers
  files: ->
    Files.find()

  filesRTS: ->
    useFontAwesome: true,
    rowsPerPage: 100,
    showFilter: true,
    class: 'table table-striped fileTable'
    fields: [
      { key: 'icon', label: '', tmpl: Template.fileIconTableCell }
      { key: 'original.name', label: 'name' }
      { key: 'metadata.published', label: 'published', tmpl: Template.filePublishedTableCell }
      { key: 'formattedSize', label: 'size' }
      { key: 'uploader', label: 'uploaded by', fn:(v,o) -> Meteor.users.findOne(o.metadata.uploaderId).emails[0].address }
      { key: 'uploadedAt', label: 'uploaded', sortByValue: true, sort: 'descending', fn: (v,o)->moment(v).fromNow() }
      { key: 'buttons', label: '', tmpl: Template.fileTableButtons }
    ]

Template.fileTableButtons.events
  "click .togglePublish": (evt)->
    Meteor.call 'togglePublishOfFile', @_id, (error) ->
      throwError error if error?
    false

  "click .remove": (evt)->
    if confirm('are you sure?')
      Meteor.call 'removeFile', @_id, (error) ->
        throwError error if error?
    false


Template.fullscreenDropArea.events
  "dragover #dropArea": (evt) ->
    evt.preventDefault()

  "dragleave #dropArea": (evt) ->
    evt.preventDefault()
    Blaze.remove dropAreaView
    dropAreaView = null

  "drop #dropArea": (evt) ->
    evt.preventDefault()
    FS.Utility.eachFile evt, (file) ->
      fsFile = new FS.File(file)
      fsFile.metadata =
        uploaderId: Meteor.userId()
      fsFile.description = fsFile.name()
      Files.insert fsFile, (error, fileObj) ->
        Blaze.remove dropAreaView
        dropAreaView = null
        throwError error if error?
    return
