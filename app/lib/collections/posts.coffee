class @Posts
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

#TODO: attach a schema

Meteor.methods
  "createPost": (title) ->
    _id = Posts.insert
      title: title
      id: toSlug(title)
      creatorId: Meteor.userId()
    _id
