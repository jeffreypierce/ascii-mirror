module.exports = (grunt) ->

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    coffee:
      dist:
        options:
          join: true
        files:
          'scripts/app.js': [
            'app/scripts/*'
          ]
          
    jade:
      dist:
        options:
          data:
            debug: false
        files:
          'index.html': ['app/views/index.jade']
    sass:
      dist:
        options:
          outputStyle: 'compressed'
          includePaths: [
          # quiet: true
          # loadPath: [
            'bower_components/bourbon/app/assets/stylesheets'
            'bower_components/neat/app/assets/stylesheets'
            'bower_components/css-modal/'
          ]
        files:
          'styles/app.css': 'app/styles/app.scss'

    watch:
      tasks: ['coffee', 'jade', 'sass']
      files: [
          'app/**/*'
        ]
      options:
        livereload: true
        
    connect:
      server:
        options:
          port: 8888

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-sass'

  grunt.registerTask 'default', ['coffee', 'jade', 'sass']
  grunt.registerTask 'server', ['connect', 'watch']
