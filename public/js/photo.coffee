app = angular.module('photoApp', ['ngAnimate', 'ngRoute', 'ngSanitize'])

app.config(['$routeProvider', '$locationProvider',
  ($routeProvider, $locationProvider) ->
    $routeProvider.when('/',
      templateUrl: 'partials/photo.html'
      controller: PhotoCtrl)
    return

])

app.directive('date', ->
  {
  restrict: 'E',
  replace: true,
  template: '<span>{{p.date | dateFilter}}</span>'
  }
)

app.filter('dateFilter', ->
  (input, param) ->
    date = new Date(input)
    return  (date.getMonth() + 1) + '-' + date.getDay()
)

window.PhotoCtrl = ['$scope', '$http', '$location', ($scope, $http, $location, $sce) ->
  $loading = $('#loading')
  $scope.photos = []
  $scope.checkIds = []
  $http.get('/api/photos').
  success((data) ->
    $loading.hide()
    $scope.years = data.list
  )
  $scope.check = (e)->
    $(e.target).toggleClass('on')
    $scope.calculate()
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
