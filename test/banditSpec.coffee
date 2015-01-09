describe "$bandit", ->
  $rootScope = $bandit = $httpBackend = null
  beforeEach inject (_$rootScope_, _$bandit_, _$httpBackend_) ->
    $rootScope = _$rootScope_
    $bandit = _$bandit_
    $httpBackend = _$httpBackend_

  describe 'data', ->
    describe 'when http request is successful', ->
      beforeEach -> backendWillRespond()

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

  describe "$reward", ->
    beforeEach ->
      backendWillRespond()
      $httpBackend.flush()

    it 'should reward an experiment', ->
      $httpBackend
        .expectPUT "https://bandit.server/ucb1", "experimentA=arm2"
        .respond 201, "ok"

      $bandit.$reward 'experimentA'

      $httpBackend.flush()
      $httpBackend.verifyNoOutstandingExpectation()

    describe 'should be a promise', ->

      it 'that resolves if backend is ok', (done) ->
        $httpBackend
          .expectPUT "https://bandit.server/ucb1", "experimentA=arm2"
          .respond 201, "ok"

        $bandit.$reward 'experimentA'
          .then -> done()
          .catch -> throw "should't fail"

        $httpBackend.flush()
        $httpBackend.verifyNoOutstandingExpectation()

      it 'that rejects if backend fails', (done) ->
        $httpBackend
          .expectPUT "https://bandit.server/ucb1", "experimentA=arm2"
          .respond 500

        $bandit.$reward 'experimentA'
          .then -> throw "should fail"
          .catch -> done()

        $httpBackend.flush()
        $httpBackend.verifyNoOutstandingExpectation()
