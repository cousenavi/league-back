var gulp = require('gulp'),
    uglify = require('gulp-uglify'),
    concat = require('gulp-concat'),
    coffee  = require('gulp-coffee'),
    notify = require('gulp-notify'),
    del = require('del');

//sourcemaps = require('gulp-sourcemaps'), TEMPORARY DISABLED


gulp.task('admin-scripts', function() {
    return gulp.src('public/admin/coffee/*.coffee')
        .pipe(coffee())
        .pipe(gulp.dest('public/admin/js/'))
        .pipe(uglify())
        .pipe(notify({ message: 'Scripts task complete' }));
});

gulp.task('deploy-js', function() {
   return gulp.src([
       'public/lib/js/jquery.min.js',
       'public/lib/js/bootstrap.min.js',
       'public/admin/js/common.js'
   ])
       .pipe(concat('libs.js'))
       .pipe(gulp.dest('public/js/'))
});

gulp.task('referee-js', function() {
    return gulp.src('public/referee/coffee/*.coffee')
        .pipe(coffee())
        .pipe(gulp.dest('public/referee/js/'))
        .pipe(uglify())
        .pipe(notify({ message: 'Scripts task complete' }));
});

gulp.task('deploy-css', function() {
   return gulp.src([
       'public/lib/css/bootstrap.min.css',
       'public/css/index.css'
   ])
       .pipe(concat('libs.min.css'))
       .pipe(gulp.dest('public/css/'))
});


gulp.task('watch', function() {
    gulp.watch('public/referee/coffee/*.coffee', ['referee-js']);
    gulp.watch('public/admin/coffee/*.coffee', ['deploy-js']);
    gulp.watch('public/admin/coffee/*.coffee', ['admin-scripts']);
});