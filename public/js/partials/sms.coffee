$(->
  body = $(window)
  aside = $('aside')
  windowHeight = body.height()
  height = 50 + 50
  $('.col-lg-10 .list').height(windowHeight - height)
  aside.height(windowHeight - 70)
  $(body).resize(->
    newHeight = body.height()
    aside.height(newHeight - 70)
    $('.col-lg-10 .list').height(newHeight - height)
    return
  )
)