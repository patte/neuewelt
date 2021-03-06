_quoteCounter = 0
_quotes = _.shuffle [
  body: "Wir müssen die Zukunft als Werkzeug nutzen, nicht als Sofa"
  footer: "#thinkaboutit #deep"
,
  body: "Die einzig ernst zu nehmende Wissenschaft ist für mich die Science-Fiction"
  footer: "Jacques Lacan"
,
  body: "Wir sind realistisch und fordern das Unmögliche"
  footer: "Irgend so ein Utopist"
,
  body: "Je m'en vais chercher le grand peut-être"
  footer: "François Rabelais"
,
  body: "The Internet became part of my life early enough to be the coolest thing ever and late enough that I have memories of Geocities before it became a howling desert rolling with tumbleweed and pixels that don’t have the decency to decay"
  footer: "Laurie Penny"
,
  body: "Arguing that you don't care about the right to privacy because you have nothing to hide is no different than saying you don't care about free speech because you have nothing to say"
  footer: "Eduard Snowden"
]
Template.home.onCreated ->
  @subscribe "posts"

firstHit = true
Template.home.onRendered ->
  document.title = "NEUE WELT"
  if firstHit
    firstHit = false
  else
    $('.drop').click()

Template.home.helpers
  posts: ->
    if Roles.userIsInRole(Meteor.user(), 'admin')
      Posts.find {},
        sort: {index: 1}
    else
      Posts.find
        published: true
      ,
        sort: {index: 1}

  quote: ->
    q = _quotes[_quoteCounter]
    _quoteCounter += 1
    _quoteCounter = 0 if _quoteCounter >= _quotes.length
    q

Template.home.events
  'click .drop': (evt) ->
    #$('.tint').toggleClass('tint-open')
    $('.projects').collapse('toggle')
    drop = $('.drop i')
    if drop.getRotationDegrees() > 0
      $(".drop i").animateRotate null, 360, 500, "swing"
    else
      $(".drop i").animateRotate null, 180, 500, "swing"

  'submit #createPost': (evt) ->
    evt.preventDefault()
    title = evt.target.title.value
    Meteor.call "createPost", title, (error, slug)->
      throwError error if error?
      Router.go 'post',
        slug: slug
    evt.target.title.value = ""
    evt.target.title.blur()
    false

  'click .togglePublish': (evt) ->
    evt.preventDefault()
    evt.stopPropagation()
    Meteor.call "togglePublishOfPost", @_id, (error)->
      throwError error if error?
    false

  'click .moveUp': (evt) ->
    evt.preventDefault()
    evt.stopPropagation()
    Meteor.call "decPostIndex", @_id, (error)->
      throwError error if error?
    false

  'click .moveDown': (evt) ->
    evt.preventDefault()
    evt.stopPropagation()
    Meteor.call "incPostIndex", @_id, (error)->
      throwError error if error?
    false

  'click .remove': (evt) ->
    if confirm("are you sure?")
      Meteor.call "removePost", @_id, (error)->
        throwError error if error?
    false
