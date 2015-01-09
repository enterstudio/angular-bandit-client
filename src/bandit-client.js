'use strict'

angular
  .module('bandit', [])

  .provider('$bandit', function() {
    var cfg = {
      experiments: {},
      uri: {}
    };

    return {
      add: function (name, arms) {
        cfg.experiments[name] = arms;
        return this;
      },

      uri: function (uri) {
        cfg.uri = uri;
        return this;
      },

      '$get': ['$q', '$http', function($q, $http) {
        var deferred = $q.defer();
        var $bandit = {
          '$resolved': false,
          '$promise': deferred.promise
        };

        var params = {}; // maps array to comma string
        angular.forEach(cfg.experiments, function(arms, name) {
          params[name] = arms.join(',');
        });

        $http.get(cfg.uri, {params: params})
          .success(function(data) {
            angular.extend($bandit, data);
          })
          .error(function() {
            angular.forEach(cfg.experiments, function(arms, name) {
              $bandit[name] = arms[0];
            });
          })
          .finally(function() {
            $bandit.$resolved = true;
            deferred.resolve($bandit);
          });

        return $bandit;
      }]
    }
  });
