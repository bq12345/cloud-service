// Generated by CoffeeScript 1.9.1
(function() {
  var _loading, app;

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

  _loading = $('#loading');

  window.CallCtrl = [
    '$scope', '$http', '$location', function($scope, $http, $location, $sce) {
      var _container;
      _container = $('#container');
      _loading.show();
      $scope.data = [];
      $scope.calls = [];
      $scope.checkIds = [];
      $http.get('/api/calls').success(function(data) {
        _loading.hide();
        _container.css('opacity', 1);
        $scope.calls = data.list;
        $scope.data = $scope.calls;
        return $scope.count = $scope.calls.length;
      });
      $scope.callCheck = function(e, n) {
        if (n.checked) {
          n.checked = '';
        } else {
          n.checked = 'on';
        }
        $scope.calculate();
      };
      $scope.checkAll = function(e) {
        if ($scope.checkedAll !== 'on') {
          $scope.checkedCalls = $scope.calls;
          $scope.calls.forEach(function(item) {
            return item.checked = 'on';
          });
          $scope.calculate();
        } else {
          $scope.batchCancel();
        }
      };
      $scope.batchCancel = function() {
        if ($scope.checkedCalls) {
          $scope.checkedCalls.forEach(function(item) {
            return item.checked = '';
          });
        }
        $scope.checkedAll = '';
        return $scope.selected = false;
      };
      $scope.calculate = function() {
        $scope.checkedCalls = $scope.calls.filter(function(item) {
          return item.checked;
        });
        $scope.checkIds = $scope.checkedCalls.map(function(item) {
          return item.id;
        });
        console.log($scope.checkIds);
        if ($scope.checkIds.length > 0) {
          if ($scope.checkIds.length === $scope.count) {
            $scope.checkedAll = 'on';
          }
          return $scope.selected = true;
        } else {
          return $scope.selected = false;
        }
      };
      $scope["delete"] = function() {
        $http.post('/api/calls/delete', {
          ids: $scope.checkIds
        }).success(function(data) {
          return console.log(data);
        });
      };
      $scope.type = function(type) {
        $scope.batchCancel();
        $scope.calls = $scope.data.filter(function(item) {
          return item.type === type;
        });
        $scope.count = $scope.calls.length;
      };
      return $scope.refresh = function() {
        $scope.calls = $scope.data;
        $scope.count = $scope.calls.length;
      };
    }
  ];

}).call(this);

//# sourceMappingURL=call.js.map
