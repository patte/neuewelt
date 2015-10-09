class @Post
  constructor: (doc) ->
    _.extend this, doc

  creator: ->
    Meteor.users.findOne _id: @creatorId

@Posts = new Meteor.Collection("posts",
  transform: (doc) ->
    new Post(doc)
)

Posts.before.insert BeforeInsertTimestampHook
Posts.before.update BeforeUpdateTimestampHook

Posts.allow
  insert: (userId, doc) ->
    false
  update: (userId, doc, fieldNames, modifier) ->
    Roles.userIsInRole(userId, 'admin')
  remove: (userId, doc) ->
    false

if Meteor.isServer
  Posts._ensureIndex( { id: 1 }, { unique: true } )

Meteor.methods
  "createPost": (title) ->
    checkIfAdmin()
    check(title, String)

    id = toSlug(title)
    post = Posts.findOne
      id: id
    throw new Meteor.Error(403, "a post with this title already exists") if post?
    
    _id = Posts.insert
      title: title
      id: id
      creatorId: Meteor.userId()
    id
