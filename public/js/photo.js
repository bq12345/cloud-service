// Generated by CoffeeScript 1.9.1
(function() {
  var _loading, app;

  app = angular.module('photoApp', ['ngAnimate', 'ngRoute', 'ngSanitize']);

  app.config([
    '$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
      $routeProvider.when('/', {
        templateUrl: 'partials/photo.html',
        controller: PhotoCtrl
      });
    }
  ]);

  app.directive('date', function() {
    return {
      restrict: 'E',
      replace: true,
      template: '<span>{{p.date | dateFilter}}</span>'
    };
  });

  app.filter('dateFilter', function() {
    return function(input, param) {
      var date;
      date = new Date(input);
      return (date.getMonth() + 1) + '-' + date.getDay();
    };
  });

  _loading = $('#loading');

  window.PhotoCtrl = [
    '$scope', '$http', '$location', function($scope, $http, $location, $sce) {
      var _container;
      _container = $('#container');
      _loading.show();
      $scope.photos = [];
      $scope.checkIds = [];
      $http.get('/api/photos').success(function(data) {
        _loading.hide();
        _container.css('opacity', 1);
        return $scope.years = data.list;
      });
      $scope.check = function($event, photo) {
        $event.stopPropagation();
        if (photo.checked) {
          photo.checked = '';
        } else {
          photo.checked = 'on';
        }
        $scope.calculate();
      };
      $scope.calculate = function() {
        $scope.checkPhotos = $scope.photos.filter(function(item) {
          return item.checked;
        });
        $scope.checkIds = $scope.checkPhotos.map(function(item) {
          return item.id;
        });
        console.log($scope.checkIds);
        if ($scope.checkIds.length > 0) {
          return $scope.selected = true;
        } else {
          return $scope.selected = false;
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

//# sourceMappingURL=photo.js.map
