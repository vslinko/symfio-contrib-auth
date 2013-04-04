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
    karma:
      unit: [
        "example/public/components/jquery/jquery.js"
        "example/public/components/angular/angular.js"
        "example/public/components/angular-resource/angular-resource.js"
        "example/public/components/angular-cookies/angular-cookies.js"
        "public/symfio-auth/plugin.coffee"
        "test/public/unit.coffee"
      ]
      e2e:
        src: "test/public/e2e.coffee"
        options:
          adapter: "angular-scenario"
      options:
        adapter: "mocha"
        browsers: ["PhantomJS"]
        container: "example/"
        reporters: [("junit" if process.env.REPORTER) or "progress"]

  grunt.loadNpmTasks "grunt-simple-mocha"
  grunt.loadNpmTasks "grunt-coffeelint"
  grunt.loadNpmTasks "symfio-suite"

  grunt.registerTask "default", [
    "simplemocha"
    "karma"
    "coffeelint"
  ]
