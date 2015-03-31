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
_loading = $('#loading')

window.CallCtrl = ['$scope', '$http', '$location', ($scope, $http, $location, $sce) ->
  _container = $('#container')
  _loading.show()
  $scope.data = []
  $scope.calls = []
  $scope.checkIds = []
  $http.get('/api/calls').
  success((data) ->
    _loading.hide()
    _container.css('opacity', 1)
    $scope.calls = data.list
    $scope.data = $scope.calls
    $scope.count = $scope.calls.length
  )
  $scope.callCheck = (e, n)->
    if n.checked
      n.checked = ''
    else
      n.checked = 'on'
    $scope.calculate()
    return

  $scope.checkAll = (e)->
    if $scope.checkedAll isnt 'on'
      $scope.checkedCalls = $scope.calls
      $scope.calls.forEach((item)->
        item.checked = 'on'
      )
      $scope.calculate()
    else
      $scope.batchCancel()
    return
  $scope.batchCancel = ->
    if $scope.checkedCalls
      $scope.checkedCalls.forEach((item)->
        item.checked = ''
      )
    $scope.checkedAll = ''
    $scope.selected = false
  $scope.calculate = ->
    $scope.checkedCalls = $scope.calls.filter((item)->
      item.checked
    )
    $scope.checkIds = $scope.checkedCalls.map((item)->
      item.id
    )
    console.log $scope.checkIds
    if $scope.checkIds.length > 0
      if $scope.checkIds.length is $scope.count
        $scope.checkedAll = 'on'
      $scope.selected = true
    else
      $scope.selected = false
  $scope.delete = ->
    $http.post('/api/calls/delete',
      ids: $scope.checkIds
    ).
    success((data)->
      console.log data
    )
    return
  $scope.type = (type)->
    $scope.batchCancel()

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
