'use strict';

var gulp = require('gulp'),
    karma = require('gulp-karma'),
    uglify = require('gulp-uglify'),
    rename = require('gulp-rename'),
    zopfli = require('gulp-zopfli');

var testingSrc = [
  'node_modules/jquery/dist/jquery.js',
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


gulp.task('dist', function(){
  return gulp
    .src('src/angular-bandit-client.js')
    .pipe(gulp.dest('dist/'))
    .pipe(uglify({preserveComments:false}))
    .pipe(rename({suffix: '.min'}))
    .pipe(gulp.dest('dist/'))
    .pipe(zopfli({append: true}))
    .pipe(gulp.dest('dist/'));
});
