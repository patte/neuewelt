Template.post.onCreated ->
  id = Router.current().params.id
  @subscribe("post", id)

Template.post.helpers
  post: ->
    id = Router.current().params.id
    Posts.findOne
      id: id
