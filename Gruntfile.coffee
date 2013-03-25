module.exports = (grunt) ->
  grunt.initConfig
    simplemocha:
      acceptance: "test/acceptance.coffee"
      unit: "test/unit.coffee"
      options: reporter: process.env.REPORTER or "spec"
    coffeelint:
      examples: "example/**/*.coffee"
      lib: "lib/**/*.coffee"
      test: "test/**/*.coffee"
      grunt: "Gruntfile.coffee"

  grunt.loadNpmTasks "grunt-simple-mocha"
  grunt.loadNpmTasks "grunt-coffeelint"

  grunt.registerTask "default", [
    "simplemocha"
    "coffeelint"
  ]
