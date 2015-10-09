Accounts.validateLoginAttempt (attempt) ->
  if attempt.user?
    return Roles.userIsInRole(attempt.user, ['admin'])
  return false
