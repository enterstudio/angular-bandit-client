describe "banditReward directive", ->
  $bandit = null
  beforeEach ->
    $bandit = initBandit()
    backendWillRespond 201
    $httpBackend.flush()

  it 'should reward a experiment on click', ->
    spyOn $bandit, '$reward'

    linkTag = $compile("<a bandit-reward='experiment'>click</a>")($rootScope)
    $rootScope.$digest()
    linkTag.click()

    expect($bandit.$reward).toHaveBeenCalledWith("experiment");

  it 'should reward multiple experiments on click', ->
    spyOn $bandit, '$reward'

    linkTag = $compile("<a bandit-reward='experimentA,experimentB'>click</a>")($rootScope)
    $rootScope.$digest()
    linkTag.click()

    expect($bandit.$reward).toHaveBeenCalledWith("experimentA", "experimentB");
