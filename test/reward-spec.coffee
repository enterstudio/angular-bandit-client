describe "$bandit.$reward", ->
  $bandit = null

  beforeEach ->
    $bandit = initBandit()
    backendWillRespond(201, {experimentA: 'arm2', experimentB: 'arm3'})
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
