// Generated by CoffeeScript 1.8.0
(function() {
  var app;

  app = angular.module('callApp', ['ngAnimate', 'ngRoute', 'ngSanitize']);

  app.config([
    '$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
      $routeProvider.when('/', {
        templateUrl: 'partials/call.html',
        controller: CallCtrl
      });
    }
  ]);

  app.directive('date', function() {
    return {
      restrict: 'E',
      replace: true,
      template: '<span>{{call.duration | dateFilter}}</span>'
    };
  });

  app.filter('dateFilter', function() {
    return function(input, param) {
      var hour, minute, second, str;
      str = '';
      hour = ~~(input / 3600);
      minute = ~~((input - hour * 3600) / 60);
      second = input - hour * 3600 - minute * 60;
      if (hour > 0) {
        str += hour + '小时';
      }
      if (minute > 0) {
        str += minute + '分';
      }
      str += second + '秒';
      return str;
    };
  });

  window.CallCtrl = [
    '$scope', '$http', '$location', function($scope, $http, $location, $sce) {
      var $loading;
      $loading = $('#loading');
      $scope.calls = [];
      $scope.checkIds = [];
      $http.get('/api/calls').success(function(data) {
        $loading.hide();
        $scope.calls = data.list;
        return $scope.count = $scope.calls.length;
      });
      $scope.check = function(e) {
        $(e.target).toggleClass('on');
        $scope.calculate();
      };
      $scope.checkAll = function(e) {
        var $checkbox;
        $checkbox = $('.checkbox');
        if ($checkbox.hasClass('on')) {
          $checkbox.removeClass('on');
        } else {
          $checkbox.addClass('on');
        }
        $scope.calculate();
      };
      $scope.calculate = function() {
        var $checks, $header;
        $checks = $('.checkbox.on', '.list');
        $scope.checkIds = $.map($checks, function(item) {
          return $(item).data('id');
        });
        console.log($scope.checkIds);
        $header = $('.content-header');
        if ($scope.checkIds.length > 0) {
          return $header.addClass('change');
        } else {
          return $header.removeClass('change');
        }
      };
      return $scope["delete"] = function() {
        $http.post('/api/post', {
          ids: $scope.checkIds
        }).success(function(data) {
          return console.log(data);
        });
      };
    }
  ];

}).call(this);

//# sourceMappingURL=call.js.map