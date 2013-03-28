crypto = require "crypto"
path = require "path"
ms = require "ms"
_ = require "lodash"


module.exports = (container, callback) ->
  connection = container.get "connection"
  mongoose = container.get "mongoose"
  expires = ms container.get "auth token expiration period", "7d"
  logger = container.get "logger"
  assets = container.get "assets serve helper"
  app = container.get "app"

  logger.info "loading plugin", "contrib-auth"

  assets path.join __dirname, "..", "public"

  hashDigest = (data) ->
    hash = crypto.createHash "sha256"
    hash.update data, "utf8"
    hash.digest "hex"

  randomHash = ->
    hashDigest String Math.random()

  passwordHash = (password, salt) ->
    hashDigest "#{password}:#{salt}"

  TokenSchema = new mongoose.Schema
    hash: type: String, required: true, index: unique: true
    expires: type: Date, required: true

  UserSchema = new mongoose.Schema
    username: type: String, required: true
    password: type: String
    passwordHash: type: String, required: true
    salt: type: String, required: true
    tokens: [TokenSchema]
    metadata: type: mongoose.Schema.Types.Mixed

  UserSchema.pre "validate", (callback) ->
    @salt = randomHash() unless @salt

    if @password
      @passwordHash = passwordHash @password, @salt
      @password = undefined

    callback()

  User = connection.model "users", UserSchema

  findUser = (tokenHash, callback) ->
    User.findOne "tokens.hash": tokenHash, (err, user) ->
      return callback err if err
      return callback() unless user

      currentToken = _.first _.filter user.tokens, (token) ->
        token.hash is tokenHash

      return callback() if new Date > currentToken.expires

      callback null, username: user.username, token: currentToken

  app.use (req, res, callback) ->
    authHeader = req.get "Authorization"

    return callback() unless authHeader
    return callback() unless authHeader.indexOf "Token " is 0

    tokenHash = authHeader.replace "Token ", ""

    findUser tokenHash, (err, user) ->
      req.user = user if user
      callback()

  app.use (req, res, callback) ->
    return callback() unless req.method is "GET"
    return callback() unless /^\/sessions\/[0-9a-f]{24}$/.test req.url

    tokenHash = req.url.replace "/sessions/", ""

    findUser tokenHash, (err, user) ->
      return res.send 500 if err
      return res.send 404 unless user
      res.send 200, token: tokenHash

  app.use (req, res, callback) ->
    return callback() unless req.method is "POST"
    return callback() unless /\/sessions\/?/.test req.url

    User.findOne username: req.body.username, (err, user) ->
      return res.send 500 if err
      return res.send 401 unless user

      if passwordHash(req.body.password, user.salt) != user.passwordHash
        return res.send 401

      tokenHash = randomHash()

      user.tokens.push
        hash: tokenHash
        expires: new Date Date.now() + expires

      user.save (err) ->
        return res.send 500 if err
        res.send 201, token: tokenHash

  callback()
