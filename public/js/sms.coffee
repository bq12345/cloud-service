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

    return  (date.getMonth() + 1) + '-' + date.getDay() + ' ' + date.getHours() + ':' + date.getMinutes()
)

window.SmsCtrl = ['$scope', '$http', '$location', ($scope, $http, $location, $sce) ->
  $loading = $('#loading')
  $scope.persons = []
  $scope.checkIds = []
  $http.get('/api/messages').
  success((data) ->
    $scope.persons = data.persons
  )
  $http.get('/api/messages.detail').
  success((data) ->
    $loading.hide()
    $scope.sms = data.sms
  )

  $scope.check = (e)->
    $(e.target).toggleClass('on')
    $scope.calculate()
    return
  $scope.peopleCheck = (e)->
    $(e.target).toggleClass('on')
    $checks = $('.checkbox.on', 'aside')
    $scope.checkPeoples = $.map($checks, (item)->
      $(item).data('id')
    )
    console.log $scope.checkPeoples
    $options = $('.options')
    if $scope.checkPeoples.length > 0
      $options.fadeIn()
    else
      $options.fadeOut()
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
