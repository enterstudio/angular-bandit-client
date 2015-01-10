TS = Number.POSITIVE_INFINITY

describe "$bandit with cache", ->

  it "should work with no cache", ->
    $httpBackend
      .expectGET "https://bandit.server/ucb1?experimentA=arm1,arm2,arm3,arm4&experimentB=arm1,arm2,arm3"
      .respond 201

    initBandit()
    $httpBackend.verifyNoOutstandingExpectation()

  it "should work with partial cache", ->
    $localForage.setItem("$bandit:experimentB", {arm: "arm2", ts: TS})
    $httpBackend
      .expectGET "https://bandit.server/ucb1?experimentA=arm1,arm2,arm3,arm4"
      .respond 201

    $bandit = initBandit()

    $httpBackend.verifyNoOutstandingExpectation()

    expect($bandit['experimentB']).toEqual("arm2")

  it "should work fully cached", ->
    $localForage.setItem("$bandit:experimentA", {arm: "arm3", ts: TS})
    $localForage.setItem("$bandit:experimentB", {arm: "arm2", ts: TS})

    $bandit = initBandit()

    $httpBackend.verifyNoOutstandingExpectation()

    expect($bandit['experimentA']).toEqual("arm3")
    expect($bandit['experimentB']).toEqual("arm2")

  it "should cache the result", (done) ->
    backendWillRespond(201, {experimentA: 'arm2', experimentB: 'arm3'})
    $bandit = initBandit()
    $httpBackend.flush()

    $q
      .all [$localForage.getItem("$bandit:experimentA"), $localForage.getItem("$bandit:experimentB")]
      .then (results) ->
        expect(results[0].arm).toEqual("arm2")
        expect(results[1].arm).toEqual("arm3")
        done()

    $rootScope.$apply()

  it "should have a ttl", ->
    $localForage.setItem("$bandit:experimentA", {arm: "arm1", ts: 0})
    backendWillRespond(201, {experimentA: 'arm2', experimentB: 'arm3'})

    $bandit = initBandit()
    $httpBackend.flush()

    expect($bandit['experimentA']).toEqual("arm2")
    expect($bandit['experimentB']).toEqual("arm3")

  it "should ignore cache if arm is nor in possible arms set", ->
    $localForage.setItem("$bandit:experimentA", {arm: "armdonotexit", ts: TS})
    backendWillRespond(201, {experimentA: 'arm2', experimentB: 'arm3'})

    $bandit = initBandit()
    $httpBackend.flush()

    expect($bandit['experimentA']).toEqual("arm2")
