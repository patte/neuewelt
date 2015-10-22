@toSlug = (text) ->
  text = replaceUmlaut text
  text.toLowerCase()
  .replace(/[^\w ]+/g, '')
  .replace RegExp(' +', 'g'), '-'
