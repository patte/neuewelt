@toSlug = (text) ->
  text.toLowerCase()
  .replace(/[^\w ]+/g, '')
  .replace RegExp(' +', 'g'), '-'
