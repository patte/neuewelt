$.fn.getRotationDegrees = ->
  obj = $(this)
  matrix = obj.css("-webkit-transform") or obj.css("-moz-transform") or obj.css("-ms-transform") or obj.css("-o-transform") or obj.css("transform")
  if matrix isnt "none"
    values = matrix.split("(")[1].split(")")[0].split(",")
    a = values[0]
    b = values[1]
    angle = Math.round(Math.atan2(b, a) * (180 / Math.PI))
  else
    angle = 0
  angle += 360  if angle < 0
  angle

$.fn.animateRotate = (startAngle, endAngle, duration, easing, complete) ->
  @each ->
    elem = $(this)
    elem.stop()
    startAngle = elem.getRotationDegrees()  if startAngle is null
    return  if startAngle is endAngle
    $(deg: startAngle).animate
      deg: endAngle
    ,
      duration: duration
      easing: easing
      step: (now) ->
        elem.css
          "-moz-transform": "rotate(" + now + "deg)"
          "-webkit-transform": "rotate(" + now + "deg)"
          "-o-transform": "rotate(" + now + "deg)"
          "-ms-transform": "rotate(" + now + "deg)"
          transform: "rotate(" + now + "deg)"

        return

      complete: complete or $.noop

    return

