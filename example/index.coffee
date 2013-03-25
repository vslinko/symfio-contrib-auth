symfio = require "symfio"

module.exports = container = symfio "example", __dirname
loader = container.get "loader"

loader.use require "symfio-contrib-express"
loader.use require "symfio-contrib-mongoose"
loader.use require "../lib/auth"
loader.use require "symfio-contrib-fixtures"

loader.use (container, callback) ->
  connection = container.get "connection"
  unloader = container.get "unloader"
  app = container.get "app"

  app.get "/", (req, res) ->
    return res.send 401 unless req.user
    res.send user: req.user

  unloader.register (callback) ->
    connection.db.dropDatabase ->
      callback()

  callback()

loader.load() if require.main is module
