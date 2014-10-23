var gulp = require('gulp'),
    uglify = require('gulp-uglify'),
    concat = require('gulp-concat'),
    coffee  = require('gulp-coffee'),
    notify = require('gulp-notify'),
    del = require('del');

//sourcemaps = require('gulp-sourcemaps'), TEMPORARY DISABLED

function handleError(err) {
    console.log(err.toString());
    this.emit('end');
}

gulp.task('admin-scripts', function() {
    return gulp.src('public/admin/coffee/*.coffee')
        .pipe(coffee())
        .pipe(gulp.dest('public/admin/js/'))
        .pipe(uglify())
        .pipe(notify({ message: 'Admin js compiled' }));
});

gulp.task('blocks-scripts', function() {
    return gulp.src('public/blocks/**/*.coffee')
        .pipe(coffee())
        .on('error', handleError)
        .pipe(gulp.dest('public/blocks/'))
        .pipe(uglify())
        .pipe(notify({ message: 'Blocks js compiled' }));
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
    return gulp.src('public/newref/coffee/*.coffee')
        .pipe(coffee({bare: true}))
        .pipe(concat('index.js'))
        .pipe(gulp.dest('public/newref/js/'))
        .pipe(uglify())
        .pipe(notify({ message: 'Referee js compiled' }));
});

gulp.task('deploy-css', function() {
   return gulp.src([
       'public/lib/css/bootstrap.min.css',
       'public/css/index.css'
   ])
       .pipe(concat('libs.min.css'))
       .pipe(gulp.dest('public/css/'))
       .pipe(notify({ message: 'Css compiled' }))
});


gulp.task('watch', function() {
    gulp.watch('public/newref/coffee/*.coffee', ['referee-js']);
    gulp.watch('public/blocks/**/*.coffee', ['blocks-scripts']);
    gulp.watch('public/admin/coffee/*.coffee', ['deploy-js']);
    gulp.watch('public/admin/coffee/*.coffee', ['admin-scripts']);
    gulp.watch('public/css/index.css', ['deploy-css']);
});