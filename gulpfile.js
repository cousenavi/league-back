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
gulp.task('admin-scripts', function() {
    return gulp.src('public/admin/coffee/*.coffee')
        .pipe(coffee())
        .pipe(gulp.dest('public/admin/js/'))
        .pipe(uglify())
        .pipe(notify({ message: 'Scripts task complete' }));
});


gulp.task('mobile-scripts-concat', function() {
    return gulp.src(['public/mobile/js/jquery-1.11.1.min.js', 'public/mobile/js/main.js'])
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
    gulp.watch('public/admin/coffee/*.coffee', ['admin-scripts']);
});