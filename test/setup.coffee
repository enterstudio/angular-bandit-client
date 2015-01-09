global = global || window

angular.module 'testApp', ['bandit']
  .config ($banditProvider) ->
    $banditProvider
      .uri "https://bandit.server/ucb1"
      .add 'experimentA', ['arm1', 'arm2', 'arm3', 'arm4']
      .add 'experimentB', ['arm1', 'arm2', 'arm3']

beforeEach ->
  module 'testApp'

global.backendWillRespond = (code = 201, data = {experimentA: 'arm2', experimentB: 'arm3'}) ->
  inject ($httpBackend) ->
    $httpBackend
      .when "GET", "https://bandit.server/ucb1?experimentA=arm1,arm2,arm3,arm4&experimentB=arm1,arm2,arm3"
      .respond code, data
