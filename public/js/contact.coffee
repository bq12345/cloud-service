###!
  Copyright baiqiang. All rights reserved.
  @file app.coffee
  @author baiqiang
  @version 1-0-0
###
###
                   _ooOoo_
                  o8888888o
                  88" . "88
                  (| -_- |)
                  O\  =  /O
               ____/`---'\____
             .'  \\|     |//  `.
            /  \\|||  :  |||//  \
           /  _||||| -:- |||||-  \
           |   | \\\  -  /// |   |
           | \_|  ''\---/''  |   |
           \  .-\__  `-`  ___/-. /
         ___`. .'  /--.--\  `. . __
      ."" '<  `.___\_<|>_/___.'  >'"".
     | | :  `- \`.;`\ _ /`;.`/ - ` : | |
     \  \ `-.   \_ __\ /__ _/   .-` /  /
======`-.____`-.___\_____/___.-`____.-'======
                   `=---='
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
         佛祖保佑       处处兼容
###

app = angular.module('myApp', ['ngAnimate', 'ngRoute', 'ngSanitize'])

app.config(['$routeProvider', '$locationProvider',
  ($routeProvider, $locationProvider) ->
    $routeProvider.when('/',
      templateUrl: 'partials/index.html'
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
window.IndexCtrl = ['$scope', '$http', '$location', ($scope, $http, $location) ->
  $loading = $('#loading')
  $scope.persons = []
  $scope.checkIds = []
  $http.get('/api/persons').
  success((data, status, headers, config) ->
    $loading.hide()
    console.log data
    $scope.persons = data.list.filter((item, i)->
      item.isdel is off
    )
    $scope.count = $scope.persons.length
  )
  $scope.addUser = ->
    $dialog = $('#dialog')
    $scope.p = {}
    $dialog.show().animate({zIndex: 1, left: '40%'}, 200)
    return
  $scope.mergeUser = ->
    $loading.show()
    setTimeout(->
      $loading.hide()
    , 1000)
    return
  $scope.modify = (i, $event) ->
    $dialog = $('#dialog')
    return if $event.target.tagName is 'INPUT' or $event.target.className.indexOf('check') > -1
    person = $scope.persons[i]
    $scope.p = person
    $dialog.show().animate({zIndex: 1, left: '40%'}, 200)
    return

  $scope.refreshUsers = ->
    location.reload()
  $scope.recycle = ->
    $('.content-header').removeClass('change')
    $('.content').html('<p class="recycle">该功能还未实现</p>')
    return

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
  $scope.save = (p)->
    $http.post('/api/cu.do', p).
    success((data)->
      $location.url('/')
    )
    return
]
