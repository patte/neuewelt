class @Crumb
  constructor: (doc) ->
    _.extend this, doc

  creator: ->
    Meteor.users.findOne _id: @creatorId

@Crumbs = new Meteor.Collection("crumbs",
  transform: (doc) ->
    new Crumb(doc)
)

Crumbs.before.insert BeforeInsertTimestampHook
Crumbs.before.update BeforeUpdateTimestampHook

Crumbs.allow
  insert: (userId, doc) ->
    false
  update: (userId, doc, fieldNames, modifier) ->
    Roles.userIsInRole(userId, 'admin')
  remove: (userId, doc) ->
    false

Meteor.methods
  'createCrumb': (postId) ->
    checkIfAdmin()
    check(postId, String)

    post = Posts.findOne
      _id: postId
    throw new Meteor.Error(403, "post with _id #{postId} not found") unless post?

    index = Crumbs.find
      postId: postId
    .count()

    _id = Crumbs.insert
      postId: postId
      creatorId: Meteor.userId()
      index: index
    _id


  'saveCrumb': (crumbId, markdown) ->
    checkIfAdmin()
    check(crumbId, String)
    markdown = null if markdown? and markdown.length is 0
    check(markdown, String)

    crumb = Crumbs.findOne
      _id: crumbId
    throw new Meteor.Error(403, "crumb with _id #{crumbId} not found") unless crumb?

    Crumbs.update crumbId,	
      $set: {content: markdown}

  'removeCrumb': (crumbId) ->
    checkIfAdmin()
    check(crumbId, String)
    Crumbs.remove crumbId
