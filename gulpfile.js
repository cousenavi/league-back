var gulp = require('gulp'),
    uglify = require('gulp-uglify'),
    concat = require('gulp-concat'),
    coffee  = require('gulp-coffee'),
    notify = require('gulp-notify'),
    del = require('del');

//sourcemaps = require('gulp-sourcemaps'), TEMPORARY DISABLED


gulp.task('mobile-scripts', function() {
    return gulp.src('public/mobile/coffee/*.coffee')
        .pipe(coffee())
        .pipe(gulp.dest('public/mobile/js/'))
        .pipe(concat('main.js'))
        .pipe(gulp.dest('public/mobile/js/'))
        .pipe(uglify())
        .pipe(gulp.dest('public/mobile/compiled/'))
        .pipe(notify({ message: 'Scripts task complete' }));
});


gulp.task('mobile-scripts-concat', function() {
    return gulp.src('public/mobile/js/*.js')
        .pipe(concat('main.js'))
        .pipe(gulp.dest('public/mobile/js/'))
        .pipe(uglify())
        .pipe(gulp.dest('public/mobile/compiled/'))
        .pipe(notify({ message: 'Scripts task complete' }));
});


//gulp.task('default', ['clean'], function() {
//    gulp.start('mobile-scripts');
//});

gulp.task('watch', function() {
    gulp.watch('public/mobile/coffee/*.coffee', ['mobile-scripts']);
});