onlyIfAdmin = ->
  if Roles.userIsInRole(@userId, ['admin'])
    return true
  else
    @ready()
    return 

onlyIfUser = ->
  if @userId
    return true
  else
    @ready()
    return

#################################################

Meteor.publish "posts", ->
  if @userId? and Roles.userIsInRole @userId, 'admin'
    Posts.find()
  else
    Posts.find
      published: true 

Meteor.publish "post", (slug) ->
  if @userId? and Roles.userIsInRole @userId, 'admin'
    Posts.find
      slug: slug
  else
    Posts.find
      published: true 
      slug: slug

Meteor.publish "crumbsForPost", (postId) ->
  Crumbs.find
    postId: postId
