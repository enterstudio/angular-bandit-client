describe "$bandit", ->
  $rootScope = $bandit = $httpBackend = null

  beforeEach inject (_$rootScope_, _$bandit_) ->
    $rootScope = _$rootScope_
    $bandit = _$bandit_


  describe 'when http request is successful', ->
    beforeEach inject (_$httpBackend_) ->
      $httpBackend = _$httpBackend_

      $httpBackend
        .when "GET", "https://bandit.server/ucb1?experimentA=arm1,arm2,arm3,arm4&experimentB=arm1,arm2,arm3"
        .respond 201, experimentA: 'arm2', experimentB: 'arm3'

    it "flags $resolved with the current state", ->
      expect($bandit.$resolved).toBe(false)
      $httpBackend.flush()
      expect($bandit.$resolved).toBe(true)

    it "fetchs the experiment arms on the bandit server", (done) ->
      $bandit.$promise.then ->
        expect($bandit['experimentA']).toBe("arm2")
        expect($bandit['experimentB']).toBe("arm3")
        done()
      $httpBackend.flush()


  describe 'when http request is not successful', ->
    beforeEach inject (_$httpBackend_) ->
      $httpBackend = _$httpBackend_
      $httpBackend
        .when "GET", "https://bandit.server/ucb1?experimentA=arm1,arm2,arm3,arm4&experimentB=arm1,arm2,arm3"
        .respond 503

    it "flags $resolved with the current state", ->
      expect($bandit.$resolved).toBe(false)
      $httpBackend.flush()
      expect($bandit.$resolved).toBe(true)

    it "picks the first possible arm as the default", (done) ->
      $bandit.$promise.then ->
        expect($bandit['experimentA']).toBe("arm1")
        expect($bandit['experimentB']).toBe("arm1")
        done()
      $httpBackend.flush()
