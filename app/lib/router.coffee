Router.configure
  layoutTemplate: "layout"
  loadingTemplate: "loading"
  notFoundTemplate: "not_found"

# automatically render notFoundTemplate if data is null
#Router.onBeforeAction('dataNotFound')
Router.onBeforeAction( ->
  AccountsEntry.signInRequired(this)	
, {only: ["users"]})

previousPage = null
Router.map ->
  @route "root",
    path: "/"
    onBeforeAction: (pause)->
      @redirect "/home"

  @route "home",
    path: "home"

  @route "post",
    path: "post/:id"
    waitOn: ->
      [
        Meteor.subscribe("post", @params.id)
      ]

if Meteor.isClient	
  Router.onBeforeAction ->
    clearErrors()
    @next()
    return

#  AccountsEntry.config
#    homeRoute: '/home' #redirect to this path after sign-out
#    dashboardRoute: '/home'  #redirect to this path after sign-in
#    passwordSignupFields: 'EMAIL'
