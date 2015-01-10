global = global || window

angular.module 'testApp', ['bandit']
  .config ($banditProvider) ->
    $banditProvider
      .uri "https://bandit.server/ucb1"
      .ttlInSeconds 60
      .add 'experimentA', ['arm1', 'arm2', 'arm3', 'arm4']
      .add 'experimentB', ['arm1', 'arm2', 'arm3']

  .service '$localForage', ($q) -> # Testing implementation
    data = {}

    return r =
      getItem: (k) ->
        deferred = $q.defer()
        deferred.resolve(data[k])
        return deferred.promise

      setItem: (k, v) ->
        data[k] = v

      clear: -> data = {}

beforeEach ->
  module 'testApp'
  inject ($rootScope, $httpBackend, $localForage, $q) ->
    global.$rootScope = $rootScope
    global.$httpBackend = $httpBackend
    global.$localForage = $localForage
    global.$q = $q

    $localForage.clear()

global.initBandit = ->
  ret = null
  inject ($bandit) -> ret = $bandit
  return ret

global.backendWillRespond = (code, data = {}) ->
  inject ($httpBackend) ->
    $httpBackend
      .when "GET", "https://bandit.server/ucb1?experimentA=arm1,arm2,arm3,arm4&experimentB=arm1,arm2,arm3"
      .respond code, data
