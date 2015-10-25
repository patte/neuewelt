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

  @route "users",
    path: "users"
    waitOn: ->
      Meteor.subscribe('users')

  @route "home",
    path: "home"

  @route "post",
    path: "post/:slug"
    waitOn: ->
      Meteor.subscribe('post', @params.slug)
    data: ->
      Posts.findOne {slug: @params.slug}


if Meteor.isClient	
  AccountsEntry.config
    homeRoute: '/home' #redirect to this path after sign-out
    dashboardRoute: '/home'  #redirect to this path after sign-in
    passwordSignupFields: 'EMAIL_ONLY'
