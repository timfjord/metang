var gulp = require('gulp'),
    karma = require('karma').server,
    concat = require('gulp-concat'),
    uglify = require('gulp-uglify'),
    rename = require('gulp-rename'),
    coffee = require('gulp-coffee'),
    gutil = require('gulp-util'),
    ngAnnotate = require('gulp-ng-annotate'),
    sourceFiles = [
      'src/metang/metang.coffee',
      'src/metang/directives/**/*.coffee',
      'src/metang/services/**/*.coffee',
      'src/metang/providers/**/*.coffee'
    ];

gulp.task('build', function() {
  gulp.src(sourceFiles)
    .pipe(concat('metang.coffee'))
    .pipe(coffee({bare: false}).on('error', gutil.log))
    .pipe(ngAnnotate())
    .pipe(gulp.dest('./dist/'))
    .pipe(uglify())
    .pipe(rename('metang.min.js'))
    .pipe(gulp.dest('./dist'));
});

/**
 * Run test once and exit
 */
gulp.task('test-src', function (done) {
  karma.start({
    configFile: __dirname + '/karma-src.conf.js',
    singleRun: true
  }, done);
});

/**
 * Run test once and exit
 */
gulp.task('test-dist-concatenated', function (done) {
  karma.start({
    configFile: __dirname + '/karma-dist-concatenated.conf.js',
    singleRun: true
  }, done);
});

/**
 * Run test once and exit
 */
gulp.task('test-dist-minified', function (done) {
  karma.start({
    configFile: __dirname + '/karma-dist-minified.conf.js',
    singleRun: true
  }, done);
});

gulp.task('default', ['test-src', 'build']);
