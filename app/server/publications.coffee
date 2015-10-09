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

Meteor.publish "post", (id) ->
  if @userId? and Roles.userIsInRole @userId, 'admin'
    Posts.find
      id: id
  else
    Posts.find
      published: true 
      id: id
