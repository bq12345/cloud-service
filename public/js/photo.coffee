###!
  Copyright © 2015. All rights reserved.
  @file photo.coffee
  @author baiqiang
  @version 1-0-0
###

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
  template: '<span>{{day.value | dateFilter}}</span>'
  }
)

app.filter('dateFilter', ->
  (input, param) ->
    date = new Date(input)
    return  (date.getMonth() + 1) + '-' + date.getDay()
)
_loading = $('#loading')
window.PhotoCtrl = ['$scope', '$http', '$location', ($scope, $http, $location, $sce) ->
  _container = $('#container')
  _loading.show()
  $scope.checkPhotos = []
  $scope.photo = false
  $scope.checkIds = []
  $http.get('/api/photos').
  success((data) ->
    _loading.hide()
    _container.css('opacity', 1)
    $scope.years = data.list
  )

  $scope.photoShow = ($event, photo)->
    $scope.photo = photo
  $scope.photoShowCancel = ->
    $scope.photo = false
  $scope.photoCheck = ($event, photo)->
    $event.stopPropagation()
    if photo.checked
      photo.checked = ''
      $scope.checkPhotos = $scope.checkPhotos.filter((item)->
        item.id isnt photo.id
      )
    else
      photo.checked = 'on'
      $scope.checkPhotos.push(photo)
    $scope.calculate()
  $scope.calculate = ->
    $scope.checkIds = $scope.checkPhotos.map((item)->
      item.id
    )
    if $scope.checkIds.length > 0
      console.log $scope.checkIds
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
  $scope.cancel = ->
    $scope.checkPhotos.forEach((item)->
      item.checked = ''
    )
    $scope.checkPhotos = []
    $scope.calculate()
    return
]