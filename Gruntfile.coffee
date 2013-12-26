module.exports = (grunt) ->

  banner = """
    /*
     * Taken from https://github.com/pozadi/bacon-reusable-parts
     * License: MIT
     * Built at: <%= grunt.template.today("yyyy-mm-dd HH:MM:ss o") %>
     */


  """

  hasNoBanner = (src) ->
    not /^\/\*/.test(grunt.file.read(src))

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    coffee:
      main:
        options:
          bare: true
        expand: true
        flatten: false
        cwd: 'src'
        src: '*.coffee'
        dest: 'dist'
        ext: '.js'
    watch:
      coffee:
        files: 'src/*.coffee'
        tasks: ['default']
    concat:
      banner:
        options:
          banner: banner
        expand: true
        flatten: false
        cwd: 'dist'
        src: '*.js'
        dest: 'dist'
        filter: hasNoBanner




  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-newer'

  grunt.registerTask 'default', ['newer:coffee', 'concat:banner']
