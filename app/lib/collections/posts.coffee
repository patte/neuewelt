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

if Meteor.isServer
  Posts._ensureIndex( { slug: 1 }, { unique: true } )

Meteor.methods
  'createPost': (title) ->
    checkIfAdmin()
    title = null if title? and title.length is 0
    check(title, String)

    slug = toSlug(title)
    post = Posts.findOne
      slug: slug
    throw new Meteor.Error(403, "a post with this title already exists") if post?
    
    _id = Posts.insert
      title: title
      slug: slug
      creatorId: Meteor.userId()
      published: false
    slug


  'togglePublishOfPost': (postId) ->
    checkIfAdmin()

    post = Posts.findOne
      _id: postId
    throw new Meteor.Error(403, "post not found") unless post?

    Posts.update postId,
      $set: 
        published: !post.published

  'removePost': (postId) ->
    checkIfAdmin()
    check(postId, String)
    Posts.remove postId
    Crumbs.remove
      postId: postId
