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
app.directive('animateOnChange', ($animate) ->
  (scope, elem, attr) ->
    scope.$watch(attr.animateOnChange, (nv, ov) ->
      console.log nv
      console.log ov
      if (nv != ov)
        c = if nv > ov then 'change-up' else 'change'
        $animate.addClass(elem, c, ->
          $animate.removeClass(elem, c)
        )
    )
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

window.NoteCtrl = ['$scope', '$http', '$location', ($scope, $http, $location, $sce) ->
  $loading = $('#loading')
  $scope.notes = []
  $scope.checkIds = []
  $http.get('/api/notes').
  success((data) ->
    $loading.hide()
    $scope.notes = data.list
    $scope.note = $scope.notes[0]
  )

  $scope.check = (e)->
    $(e.target).toggleClass('on')
    $scope.calculate()
    return
  $scope.showNote = (e)->
    console.log e
    $scope.note = $scope.notes[e]
    return
  $scope.calculate = ->
    $checks = $('.checkbox.on', '.content')
    $scope.checkIds = $.map($checks, (item)->
      $(item).data('id')
    )
    console.log $scope.checkIds
    $header = $('.content-header')
    if $scope.checkIds.length > 0
      $header.fadeIn()
    else
      $header.fadeOut()
  $scope.delete = ->
    $http.post('/api/post',
      ids: $scope.checkIds
    ).
    success((data)->
      console.log data
    )
    return
]
