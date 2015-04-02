var gulp = require('gulp');
var coffee = require('gulp-coffee');
var concat = require('gulp-concat');
var uglify = require('gulp-uglify');
var gulpif = require('gulp-if');
var del = require('del');

var paths = ['public/js/lib/angular.js', 'public/js/lib/*.js'];

var tasks = ['contact', 'sms', 'call', 'note', 'photo'];

var path = 'public/js/';

gulp.task('clean', function (cb) {
    del(['public/js/build'], cb);
});

gulp.task('scripts', ['clean'] , function () {
    tasks.forEach(function (item) {
        paths.push(path + item + '.coffee');
        gulp.src(paths)
            .pipe(gulpif(/[.]coffee$/, coffee()))
            .pipe(uglify())
            .pipe(concat(item + '.min.js'))
            .pipe(gulp.dest(path + 'build/'));
    });
});


gulp.task('default', ['scripts'] ,function(){
    console.log('Async -----Still running...');
});