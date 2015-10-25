Meteor.methods
  addUserToRoles: (user_id, roles) ->
    check(user_id, String)
    checkIfAdmin()
    Roles.addUsersToRoles(user_id, roles)

  removeUserFromRoles: (user_id, roles) ->
    check(user_id, String)
    checkIfAdmin()
    throw new Meteor.Error(403, "you can't remove yourself from the admins") if Meteor.userId() is user_id
    Roles.removeUsersFromRoles(user_id, roles)
