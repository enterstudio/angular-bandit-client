describe "$bandit", ->

  angular.module 'testApp', ['bandit']
    .config ($banditProvider) ->
      $banditProvider
        .add 'experimentA', ['arm1', 'arm2', 'arm3']
        .add 'experimentB', ['arm1', 'arm2']

  $rootScope = $bandit = null

  beforeEach ->
    module 'testApp'
    inject (_$rootScope_, _$bandit_) ->
      $rootScope = _$rootScope_
      $bandit = _$bandit_

  it "adds experiments", (done) ->
    $bandit.$promise.then ->
      expect($bandit['experimentA']).toBeDefined()
      expect($bandit['experimentB']).toBeDefined()
      done()
    $rootScope.$digest()
