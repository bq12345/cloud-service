app = angular.module('callApp', ['ngAnimate', 'ngRoute', 'ngSanitize'])

app.config(['$routeProvider', '$locationProvider',
  ($routeProvider, $locationProvider) ->
    $routeProvider.when('/',
      templateUrl: 'partials/call.html'
      controller: CallCtrl)
    return

])

app.directive('date', ->
  {
  restrict: 'E',
  replace: true,
  template: '<span>{{call.duration | dateFilter}}</span>'
  }
)

app.filter('dateFilter', ->
  (input, param) ->
    str = ''
    hour = ~~(input / 3600)
    minute = ~~((input - hour * 3600) / 60)
    second = input - hour * 3600 - minute * 60
    if hour > 0 then str += hour + '小时'
    if minute > 0 then str += minute + '分'
    str += second + '秒'
    return str
)

window.CallCtrl = ['$scope', '$http', '$location', ($scope, $http, $location, $sce) ->
  $loading = $('#loading')
  $scope.data = []
  $scope.calls = []
  $scope.checkIds = []
  $http.get('/api/calls').
  success((data) ->
    $loading.hide()
    $scope.calls = data.list
    $scope.data = $scope.calls
    $scope.count = $scope.calls.length
  )
  $scope.check = (e)->
    $(e.target).toggleClass('on')
    $scope.calculate()
    return
  $scope.checkAll = (e)->
    $checkbox = $('.checkbox')
    if $checkbox.hasClass('on')
      $checkbox.removeClass('on')
    else
      $checkbox.addClass('on')
    $scope.calculate()
    return
  $scope.calculate = ->
    $checks = $('.checkbox.on', '.list')
    $scope.checkIds = $.map($checks, (item)->
      $(item).data('id')
    )
    console.log $scope.checkIds
    $header = $('.content-header')
    if $scope.checkIds.length > 0
      $header.addClass('change')
    else
      $header.removeClass('change')
  $scope.delete = ->
    $http.post('/api/post',
      ids: $scope.checkIds
    ).
    success((data)->
      console.log data
    )
    return
  $scope.type = (type)->
    $scope.calls = $scope.data.filter((item)->
      item.type is type
    )
    $scope.count = $scope.calls.length
    return

  $scope.refresh = ->
    $scope.calls = $scope.data
    $scope.count = $scope.calls.length
    return
]
