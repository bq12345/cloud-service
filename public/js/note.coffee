app = angular.module('noteApp', ['ngAnimate', 'ngRoute', 'ngSanitize'])

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
  template: '<span>{{n.content}}</span>'
  }
)

app.filter('dateFilter', ->
  (input, param) ->
    date = new Date(input)
    return  (date.getMonth() + 1) + '-' + date.getDay() + ' ' + date.getHours() + ':' + date.getMinutes()
)
$loading = $('#loading')

window.NoteCtrl = ['$scope', '$http', '$location', ($scope, $http, $location, $sce) ->
  $loading.show()
  $scope.notes = []
  $scope.checkIds = []
  $http.get('/api/notes').
  success((data) ->
    $loading.hide()
    $scope.notes = data.list
    $scope.note = $scope.notes[0]
  )

  $scope.noteCheck = (e)->
    $(e.target).toggleClass('on')
    $scope.calculate()
    return
  $scope.showNote = (e)->
    console.log e
    $scope.note = $scope.notes[e]
    return
  $scope.calculate = ->
    $checks = $('.checkbox.on', 'aside')
    $scope.checkIds = $.map($checks, (item)->
      $(item).data('id')
    )
    $scope.checkNotes = $scope.notes.filter((item)->
      $scope.checkIds.indexOf(item.id) > -1
    )
    if $scope.checkIds.length > 0
      $scope.selected = true
    else
      $scope.selected = false
  $scope.delete = ->
    $http.post('/api/post',
      ids: $scope.checkIds
    ).
    success((data)->
      console.log data
    )
    return
]
