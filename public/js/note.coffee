###!
  Copyright © 2015. All rights reserved.
  @file note.coffee
  @author baiqiang
  @version 1-0-0
###

app = angular.module('noteApp', ['ngAnimate', 'ngRoute', 'ngSanitize', 'panel-directive'])

app.config(['$routeProvider', '$locationProvider',
  ($routeProvider, $locationProvider) ->
    $routeProvider.when('/',
      templateUrl: 'partials/note.html'
      controller: NoteCtrl)
    return
])

app.directive('date', ->
  {
  restrict: 'E',
  replace: true,
  template: '<span>{{note.date | dateFilter}}</span>'
  }
)

app.directive('title', ->
  {
  restrict: 'E',
  replace: true,
  template: '<span>{{n.content | lengthFilter}}</span>'
  }
)

#编写一个监听的指令
app.directive('watcher', ->
  {
  restrict: 'A',
  scope:
    wSpeed: "@"
    ,
  link: ($scope, el, attrs) ->
    el = angular.element(el)
    speed = $scope.wSpeed || .1
    #注意当前的作用域已经改变
    $scope.$parent.$watch('note.id', (e)->
      el.removeClass('show')
      setTimeout(->
        el.addClass('show')
      , (speed * 1000))
    , true)
  }
)
app.filter('lengthFilter', ->
  (input, param) ->
    return  if input and input.length > 20 then input.slice(0, 20) else input
)
app.filter('dateFilter', ->
  (input, param) ->
    date = new Date(input)
    return  (date.getMonth() + 1) + '-' + date.getDate() + ' ' + date.getHours() + ':' + date.getMinutes()
)
_loading = $('#loading')

window.NoteCtrl = ['$scope', '$http', '$rootScope', '$location', ($scope, $http, $rootScope, $location, $sce) ->
  _container = $('#container')
  _loading.show()
  $scope.notes = []
  $scope.checkIds = []
  $scope.paneled = false
  console.log $rootScope
  $http.get('/api/notes').
  success((data) ->
    _loading.hide()
    _container.css('opacity', 1)
    $scope.origin = data.list
    $scope.notes = data.list
    $scope.note = $scope.notes[0]
  )

  $scope.noteCheck = ($event, n)->
    $event.stopPropagation()
    if n.checked then n.checked = '' else n.checked = 'on'
    $scope.calculate()
    return
  $scope.showNote = (n)->
    $scope.edit = false
    $scope.note = $scope.notes[n.id]
    return

  $scope.calculate = ->
    $scope.checkNotes = $scope.notes.filter((item)->
      item.checked
    )
    $scope.checkIds = $scope.checkNotes.map((item)->
      item.id
    )
    console.log $scope.checkIds
    if $scope.checkIds.length > 0
      $scope.selected = true
    else
      $scope.selected = false
  #批处理页面
  $scope.batchDelete = ->
    $http.post('/api/notes/deletes',
      ids: $scope.checkIds
    ).
    success((data)->
      console.log data
    )
    return
  $scope.batchCancel = ->
    if $scope.checkNotes
      $scope.checkNotes.forEach((item)->
        item.checked = false
      )
      $scope.selected = false
    else

    return

  #编辑处理

  $scope.noteNew = ()->
    $scope.batchCancel()
    $scope.edit = true
    $scope.note =
      "content": "",
      "date": new Date().getTime()

  $scope.noteEdit = ()->
    $scope.edit = true

  $scope.noteSave = (note)->
    $scope.edit = false
    $http.post('/api/notes/save',
      id: JSON.stringify(note)
    ).
    success((data)->
      console.log data
    )
    console.log($scope.note)
  $scope.noteDelete = (n)->
    if $scope.paneled
      $scope.paneled = false
      $http.post('/api/notes/delete',
        id: n
      ).
      success((data)->
        console.log data
      )
    else
      $scope.paneled = true
  $scope.cancelDelete = (n)->
    $scope.paneled = false
  $scope.noteCancel = ->
    $scope.edit = false
]
