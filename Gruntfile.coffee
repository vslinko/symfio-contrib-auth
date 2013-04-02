module.exports = (grunt) ->
  grunt.initConfig
    simplemocha:
      acceptance: "test/acceptance.coffee"
      unit: "test/unit.coffee"
      publicAcceptance: "test/public/acceptance.coffee"
      options: reporter: process.env.REPORTER or "spec"
    coffeelint:
      examples: "example/**/*.coffee"
      lib: "lib/**/*.coffee"
      test: "test/**/*.coffee"
      grunt: "Gruntfile.coffee"
    e2e:
      plugin: "test/public/e2e/*.coffee"
      options:
        browsers: ["PhantomJS"]
        container: "example/"
        reporters: [("junit" if process.env.REPORTER) or "progress"]

  grunt.loadNpmTasks "grunt-simple-mocha"
  grunt.loadNpmTasks "grunt-coffeelint"
  grunt.loadNpmTasks "symfio-suite"

  grunt.registerTask "default", [
    "simplemocha"
    "e2e"
    "coffeelint"
  ]
