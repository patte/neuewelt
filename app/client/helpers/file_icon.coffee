Template.registerHelper "fileIcon", (file) ->
  type = file.type()
  extension = file.extension()
  if(file.isAudio())
    fa = "fa-file-audio-o"
  else if(file.isVideo())
    fa = "fa-file-video-o"
  else if(type.indexOf('pdf') isnt -1)
    fa = "fa-file-pdf-o"
  else if(type.indexOf('zip') isnt -1)
    fa = "fa-file-archive-o"
  else if(type.indexOf('text') isnt -1)
    fa = "fa-file-text-o"
  else if(extension.indexOf('doc') isnt -1)
    fa = "fa-file-word-o"
  else if(extension.indexOf('xls') isnt -1)
    fa = "fa-file-excel-o"
  else if(type.indexOf('ppt') isnt -1)
    fa = "fa-file-powerpoint-o"
  else
    fa = "fa-file-o"
  fa
