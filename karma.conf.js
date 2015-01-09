module.exports = function(config) {
  config.set({
    basePath: '.',
    frameworks: ['jasmine'],
    files: [
      'node_modules/localforage/dist/localforage.js',
      'node_modules/angular/angular.js',
      'node_modules/angular-mocks/angular-mocks.js',
      'node_modules/angular-localforage/dist/angular-localForage.js',
      "src/*.js",
      "test/setup.coffee",
      "test/*Spec.coffee"
    ],
    exclude: [],
    preprocessors: {
      '**/*.coffee': ['coffee']
    },
    reporters: ['progress'],

    port: 9876, // web server port
    colors: true,
    logLevel: config.LOG_INFO,
    browsers: ['PhantomJS'], // available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
    singleRun: true
  });
};
