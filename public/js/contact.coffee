###!
  Copyright © 2015. All rights reserved.
  @file contact.coffee
  @author baiqiang
  @version 1-0-0
###

app = angular.module('myApp', ['ngAnimate', 'ngRoute', 'ngSanitize', 'panel-directive'])

app.config(['$routeProvider', '$locationProvider',
  ($routeProvider, $locationProvider) ->
    $routeProvider.when('/',
      templateUrl: 'partials/contact.html'
      controller: IndexCtrl)
    #$locationProvider.html5Mode(true)
    return
])

app.directive('date', ->
  {
  restrict: 'E',
  replace: true,
  template: '<span>{{post.date| date:"yyyy-MM-dd HH:mm"}}</span>'
  }
)
app.service('Version', ['$rootScope', ($rootScope) ->
  {
  version: '0.0.1'
  }
])
app.directive('ngEnter', ->
  (scope, element, attrs) ->
    element.bind("keydown", (event) ->
      if(event.which is 13)
        scope.$apply(->
          scope.$eval(attrs.ngEnter)
        )
    )
)
# RESTful 的操作接口


_loading = $('#loading')


window.IndexCtrl = ['$scope', '$http', '$location', ($scope, $http, $location) ->
  _container = $('#container')
  _loading.show()
  $scope.persons = []
  $scope.checkIds = []
  $http.get('/api/persons').
  success((data, status, headers, config) ->
    _loading.hide()
    _container.css('opacity', 1)
    console.log data

    $scope.persons = data.list.filter((item, i)->
      item.isdel is off
    )
    $scope.count = $scope.persons.length
  )
  $scope.addUser = ->
    $scope.batchCancel()
    $scope.addOrUpdate = true
    $scope.p = {}
    return
  $scope.mergeUser = ->
    _loading.show()
    setTimeout(->
      _loading.hide()
    , 1000)
    return
  #批处理
  $scope.personCheck = ($event, p)->
    if p.checked then p.checked = '' else  p.checked = 'on'
    $scope.calculate()
    $event.stopPropagation()
    return
  $scope.checkAll = (e)->
    if $scope.checkedAll isnt 'on'
      $scope.checkedPersons = $scope.persons
      $scope.persons.forEach((item)->
        item.checked = 'on'
      )
      $scope.calculate()
    else
      $scope.batchCancel()
    return

  $scope.batchCancel = ->
    if $scope.checkedPersons
      $scope.checkedPersons.forEach((item)->
        item.checked = ''
      )
    $scope.checkedAll = ''
    $scope.selected = false

  $scope.calculate = ->
    $scope.checkedPersons = $scope.persons.filter((item)->
      item.checked
    )
    $scope.checkIds = $scope.checkedPersons.map((item)->
      item.id
    )
    console.log $scope.checkIds
    if $scope.checkIds.length > 0
      if $scope.checkIds.length is $scope.count
        $scope.checkedAll = 'on'
      $scope.selected = true
    else
      $scope.selected = false
  #list处理
  $scope.modify = (p) ->
    $scope.batchCancel()
    $scope.addOrUpdate = true
    $scope.p = p
    return
  $scope.cancel = ->
    $scope.addOrUpdate = false
    $scope.p = {}
    return
  $scope.refreshUsers = ->
    location.reload()
  $scope.recycle = ->
    $('.content').html('<p class="recycle">该功能还未实现</p>')
    return

  $scope.delete = ->
    $http.post('/api/post',
      ids: $scope.checkIds
    ).
    success((data)->
      console.log data
    )
    return
  $scope.save = (p)->
    $http.post('/api/cu.do', p).
    success((data)->
      $location.url('/')
    )
    return
]
