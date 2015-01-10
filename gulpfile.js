'use strict';

var gulp = require('gulp'),
    karma = require('gulp-karma');

var testingSrc = [
  'node_modules/localforage/dist/localforage.js',
  'node_modules/angular/angular.js',
  'node_modules/angular-mocks/angular-mocks.js',
  'node_modules/angular-localforage/dist/angular-localForage.js',
  "src/*.js",
  "test/setup.coffee",
  "test/*-spec.coffee"
]

gulp.task('test', function() {
  return gulp
    .src(testingSrc)
    .pipe(karma({
        configFile: 'karma.conf.js',
        action: 'run'
    }))
    .on('error', function(err) {
      throw err; // Make sure failed tests cause gulp to exit non-zero
    });
});

gulp.task('test:watch', function() {
  return gulp
    .src(testingSrc)
    .pipe(karma({
      configFile: 'karma.conf.js',
      action: 'watch'
    }))
});
