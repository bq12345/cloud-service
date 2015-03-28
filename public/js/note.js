// Generated by CoffeeScript 1.9.1
(function() {
  var $loading, app;

  app = angular.module('noteApp', ['ngAnimate', 'ngRoute', 'ngSanitize']);

  app.config([
    '$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
      $routeProvider.when('/', {
        templateUrl: 'partials/note.html',
        controller: NoteCtrl
      });
    }
  ]);

  app.directive('date', function() {
    return {
      restrict: 'E',
      replace: true,
      template: '<span>{{note.date | dateFilter}}</span>'
    };
  });

  app.directive('title', function() {
    return {
      restrict: 'E',
      replace: true,
      template: '<span>{{n.content}}</span>'
    };
  });

  app.filter('dateFilter', function() {
    return function(input, param) {
      var date;
      date = new Date(input);
      return (date.getMonth() + 1) + '-' + date.getDay() + ' ' + date.getHours() + ':' + date.getMinutes();
    };
  });

  $loading = $('#loading');

  window.NoteCtrl = [
    '$scope', '$http', '$location', function($scope, $http, $location, $sce) {
      $loading.show();
      $scope.notes = [];
      $scope.checkIds = [];
      $http.get('/api/notes').success(function(data) {
        $loading.hide();
        $scope.notes = data.list;
        return $scope.note = $scope.notes[0];
      });
      $scope.noteCheck = function(e) {
        $(e.target).toggleClass('on');
        $scope.calculate();
      };
      $scope.showNote = function(e) {
        console.log(e);
        $scope.note = $scope.notes[e];
      };
      $scope.calculate = function() {
        var $checks;
        $checks = $('.checkbox.on', 'aside');
        $scope.checkIds = $.map($checks, function(item) {
          return $(item).data('id');
        });
        $scope.checkNotes = $scope.notes.filter(function(item) {
          return $scope.checkIds.indexOf(item.id) > -1;
        });
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

//# sourceMappingURL=note.js.map
