'use strict'

angular
  .module('mabExampleApp', ['ngSanitize', 'ui.router', 'bandit'])

  .config ($stateProvider, $urlRouterProvider, $locationProvider) ->
    $locationProvider.html5Mode(true)

    $stateProvider
      .state 'download',
        url: '/'
        templateUrl: 'download.html'
        controller: 'DownloadCtrl'

  .controller 'DownloadCtrl', ($scope, $bandit) ->
    $scope.reset = ->
      localforage.clear().then -> document.location.reload(true)

    $bandit.$promise.then ->
      $scope.json = angular.toJson($bandit, 2)

  .config ($banditProvider) ->
    $banditProvider
      .uri "https://bandit-server.herokuapp.com/ucb1"
      .add 'actionsLayout', ['left','center']
      .add 'downloadButtonText', ['getit','appon']
      .add 'downloadButtonSize', ['regular', 'big']

  .run ($rootScope, $bandit) ->
    $rootScope.$bandit = $bandit
