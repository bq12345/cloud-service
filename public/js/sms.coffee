app = angular.module('smsApp', ['ngAnimate', 'ngRoute', 'ngSanitize'])

app.config(['$routeProvider', '$locationProvider',
  ($routeProvider, $locationProvider) ->
    $routeProvider.when('/',
      templateUrl: 'partials/sms.html'
      controller: SmsCtrl)
    return
])

app.directive('date', ->
  {
  restrict: 'E',
  replace: true,
  template: '<span>{{msg.date | dateFilter}}</span>'
  }
)

app.filter('dateFilter', ->
  (input, param) ->
    date = new Date(input)
    return  (date.getMonth() + 1) + '-' + date.getDate() + ' ' + date.getHours() + ':' + date.getMinutes()
)
_loading = $('#loading')
window.SmsCtrl = ['$scope', '$http', '$location', ($scope, $http, $location, $sce) ->
  _container = $('#container')
  _loading.show()
  $scope.persons = []
  $scope.checkIds = []
  $http.get('/api/messages').
  success((data) ->
    $scope.persons = data.persons
    $scope.p = $scope.persons[0]
  )
  $http.get('/api/messages/detail').
  success((data) ->
    _loading.hide()
    _container.css('opacity', 1)
    $scope.sms = data.sms
  )
  #点击事件处理
  $scope.smsShow = (p)->
    $scope.p = p
    $http.get('/api/messages/detail').
    success((data) ->
      $scope.sms = data.sms
    )

  $scope.personCheck = (e, p)->
    if p.checked
      p.checked = ''
    else
      p.checked = 'on'
    $scope.calculate()
  $scope.calculate = ->
    $scope.checkedPersons = $scope.persons.filter((item)->
      item.checked
    )
    $scope.checkIds = $scope.checkedPersons.map((item)->
      item.id
    )
    console.log $scope.checkIds
    if $scope.checkIds.length > 0
      $scope.selected = true
    else
      $scope.selected = false

  #批处理页面
  $scope.batchCancel = ->
    if $scope.checkedPersons
      $scope.checkedPersons.forEach((item)->
        item.checked = ''
      )
    $scope.checkedAll = ''
    $scope.selected = false
  $scope.batchDelete = ->
    $scope.batchCancel()
    $http.post('/api/sms/deletes',
      ids: $scope.checkIds
    ).
    success((data)->
      console.log data
    )
  #详情页处理
  $scope.msgDelete = (msg)->
    console.log msg
    $http.get('/api/sms/delete').
    success((data) ->
      $scope.sms = data.sms
    )
]
