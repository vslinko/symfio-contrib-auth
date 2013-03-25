symfio = require "symfio"
plugin = require "../lib/auth"
suite = require "symfio-suite"


describe "contrib-auth plugin", ->
  wrapper = suite.sandbox symfio, ->
    @connection = model: @sandbox.stub()
    @tokenHash = "0123456789abcdef01234567"
    @model = findOne: @sandbox.stub()
    @app = use: @sandbox.stub()
    @req = get: @sandbox.stub().returns "Token #{@tokenHash}"
    @res = send: @sandbox.stub()

    @mongoose = Schema: ->
    @mongoose.Schema.Types = Mixed: null
    @mongoose.Schema.prototype.pre = @sandbox.stub()

    @connection.model.returns @model

    @container.set "connection", @connection
    @container.set "mongoose", @mongoose
    @container.set "app", @app

  it "should populate user in request object", wrapper ->
    user = username: "username", tokens: [
      hash: @tokenHash, expires: new Date Date.now() + 10000
    ]

    @model.findOne.yields null, user

    plugin @container, ->

    populateMiddleware = @app.use.firstCall.args[0]
    populateMiddleware @req, null, ->

    @expect(@req).to.have.property "user"
    @expect(@req.user.username).to.equal user.username
    @expect(@req.user.token.hash).to.equal @tokenHash

  it "shouldn't populate user if token is expired", wrapper ->
    user = username: "nameuser", tokens: [
      hash: @tokenHash, expires: new Date Date.now() - 10000
    ]

    @model.findOne.yields null, user

    plugin @container, ->

    populateMiddleware = @app.use.firstCall.args[0]
    populateMiddleware @req, null, ->

    @expect(@req).to.not.have.property "user"

  it "should respond with 500 if mongodb request is failed", wrapper ->
    @req.method = "POST"
    @req.url = "/sessions"
    @req.body = username: "username"

    @model.findOne.yields new Error

    plugin @container, ->

    authenticateMiddleware = @app.use.lastCall.args[0]
    authenticateMiddleware @req, @res, ->

    @expect(@res.send).to.have.been.calledOnce
    @expect(@res.send).to.have.been.calledWith 500

  it "should respond with 200 if session exists", wrapper ->
    @req.method = "GET"
    @req.url = "/sessions/#{@tokenHash}"
    @req._parsedUrl = pathname: @req.url

    user = username: "nameuser", tokens: [
      hash: @tokenHash, expires: new Date Date.now() + 10000
    ]

    @model.findOne.yields null, user

    plugin @container, ->

    sessionCheckerMiddleware = @app.use.secondCall.args[0]
    sessionCheckerMiddleware @req, @res, ->

    @expect(@res.send).to.have.been.calledOnce
    @expect(@res.send).to.have.been.calledWith 200

  it "should respond with 404 if session doesn't exists", wrapper ->
    @req.method = "GET"
    @req.url = "/sessions/#{@tokenHash}"
    @req._parsedUrl = pathname: @req.url

    user = username: "nameuser", tokens: [
      hash: @tokenHash, expires: new Date Date.now() - 10000
    ]

    @model.findOne.yields null, user

    plugin @container, ->

    sessionCheckerMiddleware = @app.use.secondCall.args[0]
    sessionCheckerMiddleware @req, @res, ->

    @expect(@res.send).to.have.been.calledOnce
    @expect(@res.send).to.have.been.calledWith 404
