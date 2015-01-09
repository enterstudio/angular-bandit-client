'use strict'

angular
  .module('bandit', [])

  .provider('$bandit', function() {
    var cfg = {
      experiments: {}
    };

    return {
      add: function (name, arms) {
        cfg.experiments[name] = arms;
        return this;
      },

      '$get': ['$q', function($q) {
        var deferred = $q.defer();
        var $bandit = {
          '$resolved': false,
          '$promise': deferred.promise
        };

        angular.forEach(cfg.experiments, function(arms, name) {
          $bandit[name] = arms[0];
        });

        deferred.resolve($bandit);
        return $bandit;
      }]
    }
  });
