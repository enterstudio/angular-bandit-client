describe "$bandit", ->
  $bandit = null
  beforeEach -> $bandit = initBandit()

  describe 'when http request is successful', ->
    beforeEach ->
      backendWillRespond(201, {experimentA: 'arm2', experimentB: 'arm3'})

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
    beforeEach -> backendWillRespond(503)

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
