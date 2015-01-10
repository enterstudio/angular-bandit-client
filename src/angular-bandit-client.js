'use strict';
(function(angular) {

angular
  .module('bandit', ['LocalForageModule'])

  .directive('banditReward', function($bandit) {
    return {
      restrict: 'A',
      link: function(scope, el$, attrs) {
        el$.on('click', function() {
          $bandit.$reward.apply($bandit, attrs.banditReward.split(","));
        });
      }
    }
  })

  .provider('$bandit', function() {
    var cfg = {
      experiments: {},
      uri: {},
      tts: 7 * 24 * 60 * 60 * 1000 // 7 days
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

      ttlInSeconds: function (seconds) {
        cfg.ttl = seconds * 1000;
        return this;
      },

      '$get': ['$q', '$http', '$localForage', function($q, $http, $localForage) {
        var deferred = $q.defer();
        var $bandit = {
          '$resolved': false,
          '$promise': deferred.promise,
          '$reward': function() {
            var rewards = {};
            angular.forEach(arguments, function(exp) {
              rewards[exp] = $bandit[exp];
            });

            if (Object.keys(rewards) == 0){ return; }

            return $http.put(cfg.uri, rewards, {
                transformRequest: toFormUrlEncoded,
                headers: {'Content-Type': 'application/x-www-form-urlencoded'}
            });
          }
        };

        var notInCache = {};

        var promises = [];
        angular.forEach(cfg.experiments, function(arms, name) {
          var p = $localForage.getItem("$bandit:" + name)
            .then(function(item){
              if (isCacheValid(item, arms, cfg)) {
                $bandit[name] = item.arm;
              } else {
                notInCache[name] = arms.join(',')
              }
            })
            .catch(function() {
              notInCache[name] = arms.join(',')
            });

          promises.push(p)
        });

        $q.all(promises).finally(function(){
          if (Object.keys(notInCache).length == 0) {
            $bandit.$resolved = true;
            deferred.resolve($bandit);
            saveCache($bandit, $localForage)
            return;
          }

          $http.get(cfg.uri, {params: notInCache})
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
              saveCache($bandit, $localForage)
            });
        });

        return $bandit;
      }]
    }
  });

function isCacheValid(item, arms, cfg) {
  return !!item && arms.indexOf(item.arm) > -1 && item.ts > (new Date().getTime() - cfg.ttl)
}

function saveCache($bandit, $localForage) {
  angular.forEach($bandit, function(arm, name) {
    $localForage.setItem("$bandit:" + name, {arm: arm, ts: new Date().getTime()})
  })
};

function toFormUrlEncoded(obj) {
  var formData = [];
  angular.forEach(obj, function(v, k) {
    formData.push(encodeURIComponent(k) + "=" + encodeURIComponent(v));
  });

  return formData.join("&");
};


})(angular);
