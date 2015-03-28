$(->
  body = $(window)
  aside = $('aside')
  main =
  windowHeight = body.height()
  height = 50 + 45 + 50
  $('.col-lg-10 .list').height(windowHeight - height)
  aside.height(windowHeight - 50)
  $(body).resize(->
    newHeight = body.height()
    aside.height(newHeight - 50)
    $('.col-lg-10 .list').height(newHeight - height)
    return
  )
  $('#close-dialog').click(->
    dialog = $('#dialog')
    dialog.animate(
      left: '100%'
    , 200, ->
      dialog.css(
        zIndex: 0
      )
      dialog.hide()
    )
  )
)