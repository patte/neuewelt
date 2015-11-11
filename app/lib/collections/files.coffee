@Files = new (FS.Collection)('files',
  stores: [ 
    new FS.Store.GridFS('files')
  ]
)

Files.allow
  insert: (userId, doc) ->
    Roles.userIsInRole userId, 'admin'
  update: (userId, doc, fieldNames, modifier) ->
    false
  remove: (userId, doc) ->
    false
  download: (userId, doc) ->
    (doc.metadata? and doc.metadata.published) or
    Roles.userIsInRole userId, 'admin'

Meteor.methods
  'togglePublishOfFile': (fileId) ->
    checkIfAdmin()
    check(fileId, String)

    file = Files.findOne
      _id: fileId
    throw new Meteor.Error(403, "file not found") unless file?

    published = file.metadata.published || false

    Files.update fileId,
      $set: 
        'metadata.published': !published

  'removeFile': (fileId) ->
    checkIfAdmin()
    check(fileId, String)
    Files.remove fileId
