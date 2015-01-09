angular.module 'testApp', ['bandit']
  .config ($banditProvider) ->
    $banditProvider
      .uri "https://bandit.server/ucb1"
      .add 'experimentA', ['arm1', 'arm2', 'arm3', 'arm4']
      .add 'experimentB', ['arm1', 'arm2', 'arm3']

beforeEach ->
  module 'testApp'
