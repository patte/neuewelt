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
  return unless onlyIfAdmin.call(@) 
  Posts.find()

Meteor.publish "post", (id) ->
  return unless onlyIfAdmin.call(@) 
  Posts.find(id: id)

