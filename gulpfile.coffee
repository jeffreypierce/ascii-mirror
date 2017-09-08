gulp = require 'gulp'
coffee = require 'gulp-coffee'
styl = require 'gulp-stylus'
pug = require 'gulp-pug'
concat = require 'gulp-concat'
rename = require 'gulp-rename'
uglify = require 'gulp-uglify'
autoprefixer = require 'gulp-autoprefixer'
livereload = require 'gulp-livereload'
connect = require 'gulp-connect'
del = require 'del'

config =
  src: './src/'
  dist: './dist/'
  port: 8000

paths =
  scripts: "#{config.src}scripts/*.coffee"
  styles: "#{config.src}styles/*.styl"
  views: "#{config.src}views/*.pug"

gulp.task 'scripts', ()->
  gulp.src paths.scripts
    .pipe connect.reload()
    .pipe coffee({bare: true})
    .pipe concat('app.js')
    .pipe gulp.dest(config.dist)
    .pipe rename({ suffix: '.min' })
    .pipe uglify()
    .pipe gulp.dest(config.dist)

gulp.task 'styles', ()->
  gulp.src paths.styles
    .pipe connect.reload()
    .pipe styl()
    .pipe autoprefixer('last 2 version')
    .pipe gulp.dest(config.dist)

gulp.task 'views', ()->
  gulp.src paths.views
    .pipe connect.reload()
    .pipe pug()
    .pipe gulp.dest(config.dist)

gulp.task 'clean', (cb)->
  del ['./dist/'], cb

gulp.task 'watch', ()->
  gulp.watch paths.scripts, ['scripts']
  gulp.watch paths.styles, ['styles']
  gulp.watch paths.views, ['views']

gulp.task 'connect', ['watch'], ()->
  connect.server
    root: config.dist
    livereload: true

gulp.task 'default', ['clean'], ()->
  gulp.start 'scripts', 'styles', 'views'

gulp.task 'server', ['default', 'connect']
