$(->
  body = $(window)
  aside = $('aside')
  windowHeight = body.height()
  height = 50 + 50
  $('#detail-text').height(windowHeight - height)
  aside.height(windowHeight - 70)
  $(body).resize(->
    newHeight = body.height()
    aside.height(newHeight - 70)
    $('#detail-text').height(newHeight - height)
    return
  )
)