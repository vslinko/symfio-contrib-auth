symfio = require "symfio"
path = require "path"
fs = require "fs.extra"

module.exports = container = symfio "example", __dirname
container.set "public directory", path.join __dirname, "public"
container.set "components", [
  "angular#~1.0",
  "angular-resource#~1.0",
  "angular-cookies#~1.0",
  "jquery#~1.9"
]

loader = container.get "loader"
loader.use require "symfio-contrib-express"
loader.use require "symfio-contrib-mongoose"
loader.use require "symfio-contrib-assets"
loader.use require "../lib/auth"
loader.use require "symfio-contrib-fixtures"
loader.use require "symfio-contrib-bower"

loader.use (container, callback) ->
  connection = container.get "connection"
  unloader = container.get "unloader"
  app = container.get "app"

  app.get "/user", (req, res) ->
    return res.send 401 unless req.user
    res.send user: req.user

  unloader.register (callback) ->
    connection.db.dropDatabase ->
      callback()

  unloader.register (callback) ->
    fs.remove "#{__dirname}/.components", ->
      fs.remove "#{__dirname}/components", ->
        callback()

  callback()

loader.load() if require.main is module
