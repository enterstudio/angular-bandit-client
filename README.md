# Angular Bandit Client

[angular-bandit-client](https://github.com/peleteiro/angular-bandit-client/) helps you improve you application using Multi-Armed Bandit through [bandit-server](https://github.com/peleteiro/bandit-server/).

## Multi-armed what?!

A multi-armed bandit is essentially an online alternative to classical A/B testing. Whereas A/B testing is generally split into extended phases of execution and analysis, Bandit algorithms continually adjust to user feedback and optimize between experimental states. Bandits typically require very little curation and can in fact be left running indefinitely if need be.

Read more on [bandit-server](https://github.com/peleteiro/bandit-server/) project page.

## Requirements

- [AngularJS](https://angularjs.org/)
- [angular-localForage](https://github.com/ocombe/angular-localForage)

## Usage

### Download
- Using [bower](http://bower.io/) to install it. `bower install angular-bandit-client --save`
- Using [npm](https://www.npmjs.com/) to install it. `npm install angular-bandit-client --save`
- [Download](https://github.com/peleteiro/angular-bandit-client/archive/master.zip) from github.

### Load Script
Load the script file: `angular-bandit-client.js` or `angular-bandit-client.min.js` in your application:

```html
<script type="text/javascript" src="/bower_components/angular-bandit-client/dist/angular-bandit-client.js"></script>
```

### Configure
Add the bandit module as a dependency to your application module:

```js
var myAppModule = angular.module('MyApp', ['bandit'])

myAppModule.configure(function($banditProvider) {
  $banditProvider
    .uri("http://mybandit.server/ucb1")
    .ttlInSeconds(7 * 24 * 60 * 60)
    .add('experiment', ['arm1', 'arm2', 'arm3', 'arm4'])
    .add('downloadColor', ['green', 'black', 'white'])
    .add('downloadText', ['plain', 'now!']);
});
```

### Using

Most of the experiments I made are reflected on the UI, like colours, positions or different versions of a text. So I usually put the $bandit object in the $rootScope:

```js
myAppModule.run(function($rootScope, $bandit) {
  $rootScope.$bandit = $bandit;
});
```

```html
<a ng-click="download()" ng-class="$bandit.downloadColor">
  <span ng-if="$bandit.downloadText == 'plain'">Download</span>
  <span ng-if="$bandit.downloadText == 'now!'">Download Now!</span>
</a>
```

### Reward

An important step is notifying the backend when an experiment's arm is rewarded.

- ``$bandit.$reward('experiment name', ...)``

```js
myAppModule.controller("DownloadCtrl", function($scope, $bandit) {  
  $scope.download = function() {
    $bandit.$reward('downloadColor', 'downloadText');
    ...
  };
});
```

- banditReward directive:

```html
<a ng-click="download()" ng-class="$bandit.downloadColor" bandit-reward="downloadColor,downloadText">
  <span ng-if="$bandit.downloadText == 'plain'">Download</span>
  <span ng-if="$bandit.downloadText == 'now!'">Download Now!</span>
</a>
```

### Loading state

Experiments are async loaded from the local cache or http backend; and some experiments may not be loaded at the time you use it (especially the ones that are not in cache). $bandit mimics angular-resource results and provides:

- ``$bandit.$resolved``: true after all data is loaded (either with success or rejection), false before that.
- ``$bandit.$promise``: resolved after all the data is loaded, fails if the backend request fails.

If backend fails, it will draw the first arm in each experiment (that are not cached) as default.


# Contributing

We encourage you to contribute! Please check out the guidelines about how to proceed.

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.

* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it

* Fork the project

* Start a feature/bugfix branch

* Commit and push until you are happy with your contribution
Make sure to add tests for the feature/bugfix. This is important so I don't break it in a future version unintentionally.

* Please try not to mess with the gulpfile.js, package.json, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate it to its own commit so I can cherry-pick around it.

# License

angular-bandit-client is released under the [MIT License](http://www.opensource.org/licenses/MIT).
