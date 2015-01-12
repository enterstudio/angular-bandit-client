'use strict';
var path = require('path'),
    gulp = require('gulp'),
    gutil = require('gulp-util'),
    watch = require('gulp-watch'),
    plumber = require('gulp-plumber'),
    del = require('del'),
    connect = require('gulp-connect'),
    sass = require('gulp-sass'),
    autoprefixer = require('gulp-autoprefixer'),
    sourcemaps = require('gulp-sourcemaps'),
    coffee = require('gulp-coffee'),
    ngAnnotate = require('gulp-ng-annotate'),
    minifyHtml = require('gulp-minify-html'),
    templateCache = require('gulp-angular-templatecache');


gulp.task('clean', function(cb) {
  del(["dist/**"], cb)
});

gulp.task('css', function() {
  return gulp
    .src("src/styles/main.scss")
    .pipe(sass())
    .pipe(autoprefixer({browsers: ['last 2 versions']}))
    .pipe(gulp.dest('.tmp/styles'));
})

gulp.task('js', function() {
  return gulp.src('src/scripts/**/*.coffee')
  .pipe(plumber())
  .pipe(sourcemaps.init())
  .pipe(coffee({}).on('error', gutil.log))
  .pipe(ngAnnotate())
  .pipe(sourcemaps.write("."))
  .pipe(gulp.dest('.tmp/scripts'))
});

gulp.task('templates', function() {
  return gulp.src(['src/views/**/*.html'])
  .pipe(minifyHtml({empty: true, quotes: true}))
  .pipe(templateCache({module: 'mabExampleApp'}))
  .pipe(gulp.dest('.tmp/scripts'));
});

gulp.task("watch", function() {
  gulp.watch("src/styles/**/*.scss", ['css']);
  gulp.watch("src/scripts/**/*.coffee", ['js']);
  gulp.watch("src/views/**/*.html", ['templates']);
  gulp.watch(["src/index.html", "src/**/*.css", ".tmp/**/*.css", "src/**/*.js", ".tmp/**/*.js"], function(files) {
    gulp.src(files.path).pipe(connect.reload());
  });
});

gulp.task('server', ['css', 'js', 'templates', 'watch'], function() {
  return connect.server({
    root: ['.tmp', 'src', '../'],
    port: 3000,
    livereload: true,
    middleware: function(connect, options) {
      var middlewares = [];

      var modRewrite = require('connect-modrewrite');
      middlewares.push(modRewrite(['^[^\\.]*$ /index.html [L]'])); //Matches everything that does not contain a '.' (period)

      options.root.forEach(function(base) {
        middlewares.push(connect.static(base));
      });

      return middlewares;
    }
  });
});
