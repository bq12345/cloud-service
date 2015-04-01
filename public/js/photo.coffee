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
  $scope.photos = []
  $scope.checkIds = []
  $http.get('/api/photos').
  success((data) ->
    _loading.hide()
    _container.css('opacity', 1)
    $scope.years = data.list
  )
  $scope.photoCheck = ($event, photo)->
    console.log $scope
    console.log $event
    #console.log photo
    #$event.stopPropagation()
    if photo.checked then photo.checked = '' else  photo.checked = 'on'
    $scope.calculate()
    return
  $scope.calculate = ->
    $scope.checkPhotos = $scope.photos.filter((item)->
      item.checked
    )
    $scope.checkIds = $scope.checkPhotos.map((item)->
      item.id
    )
    console.log $scope.checkIds
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

window.ItemCtrl = ['$scope', '$http', '$location', ($scope, $http, $location, $sce) ->

  $scope.items = []
  $scope.photoCheck = ($event, photo)->
    console.log $scope
    console.log $event
    #console.log photo
    #$event.stopPropagation()
    if photo.checked then photo.checked = '' else  photo.checked = 'on'
    $scope.calculate()
    return
  $scope.calculate = ->
    $scope.checkPhotos = $scope.photos.filter((item)->
      item.checked
    )
    $scope.checkIds = $scope.checkPhotos.map((item)->
      item.id
    )
    console.log $scope.checkIds
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