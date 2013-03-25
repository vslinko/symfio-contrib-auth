suite = require "symfio-suite"


describe "contrib-auth example", ->
  wrapper = suite.http require "../example"

  describe "POST /sessions", ->
    it "should authenticate user", wrapper (callback) ->
      test = @http.post "/sessions"

      test.req (req) ->
        req.send username: "username", password: "password"

      test.res (res) =>
        @expect(res).to.have.status 201
        @expect(res.body).to.have.property "token"

        process.nextTick =>
          test = @http.get "/"

          test.req (req) ->
            req.set "Authorization", "Token #{res.body.token}"

          test.res (res) =>
            @expect(res).to.have.status 200
            @expect(res.body).to.have.property "user"
            callback()

    it "should respond with 401 if user not found", wrapper (callback) ->
      test = @http.post "/sessions"

      test.req (req) ->
        req.send username: "notfound", password: "password"

      test.res (res) =>
        @expect(res).to.have.status 401
        callback()

    it "should respond with 401 if password is invalid", wrapper (callback) ->
      test = @http.post "/sessions"

      test.req (req) ->
        req.send username: "username", password: "invalid"

      test.res (res) =>
        @expect(res).to.have.status 401
        callback()
