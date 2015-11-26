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

    index = Posts.find().count()

    _id = Posts.insert
      title: title
      slug: slug
      creatorId: Meteor.userId()
      published: false
      index: index
    slug


  'changePostTitle': (postId, title) ->
    checkIfAdmin()
    check(postId, String)
    title = null if title? and title.length is 0
    check(title, String)

    post = Posts.findOne postId
    throw new Meteor.Error(403, "a post with the claimed _id can't be found.") unless post?

    slug = toSlug(title)
    anotherPost = Posts.findOne
      _id: {$ne: postId}
      slug: slug
    throw new Meteor.Error(403, "a post with this title already exists") if anotherPost?

    Posts.update postId,
      $set:
        title: title
        slug: slug
    slug


  'togglePublishOfPost': (postId) ->
    checkIfAdmin()
    check(postId, String)

    post = Posts.findOne
      _id: postId
    throw new Meteor.Error(403, "post not found") unless post?

    Posts.update postId,
      $set:
        published: !post.published

  'decPostIndex': (postId) ->
    checkIfAdmin()
    check(postId, String)

    post = Posts.findOne
      _id: postId
    throw new Meteor.Error(403, "post not found") unless post?

    return if post.index is 0

    Posts.update
      index: post.index-1
    ,
      $inc: {index: 1}

    Posts.update postId,
      $inc: {index: -1}


  'incPostIndex': (postId) ->
    checkIfAdmin()
    check(postId, String)

    post = Posts.findOne
      _id: postId
    throw new Meteor.Error(403, "post not found") unless post?

    numPosts = Posts.find().count()
    return if post.index is numPosts-1

    Posts.update
      index: post.index+1
    ,
      $inc: {index: -1}

    Posts.update postId,
      $inc: {index: 1}


  'removePost': (postId) ->
    checkIfAdmin()
    check(postId, String)

    post = Posts.findOne
      _id: postId
    throw new Meteor.Error(403, "post not found") unless post?

    Posts.remove postId
    Crumbs.remove
      postId: postId

    Posts.update
      index: {$gt: post.index}
    ,
      $inc: {index: -1}
    ,
      multi: true

    #fix wrong indices
    i = 0
    Posts.find({}, {sort: {index: 1}}).forEach (p) ->
      Posts.update p._id,
        $set: {index: i}
      i += 1
