suite = require "symfio-suite"


describe "contrib-auth plugin example", ->
  wrapper = suite.browser require "../../example"

  it "should render auth plugin", wrapper (callback) ->
    @browser.visit "/", =>
      @assert.ok @browser.query "input[name='username']"
      @assert.ok @browser.query "input[name='password']"
      callback()

  it "should login text configured from provider", wrapper (callback) ->
    @browser.visit "/", =>
      @assert.ok @browser.xpath "//*[text()='Login text from config provider']"
      callback()

  it "should password text configured from attrs", wrapper (callback) ->
    @browser.visit "/", =>
      @assert.ok @browser.xpath "//*[text()='Password text from attrs']"
      callback()

  it "should show error message when invalid", wrapper (callback) ->
    @browser.visit "/", =>
      errorMessage = @browser.query ".symfio-auth-error-message"
      @assert.ok errorMessage
      @assert.equal "none", errorMessage.style.getPropertyValue "display"

      @browser.fill "username", "invalid"
      @browser.fill "password", "invalid"
      @browser.pressButton "Send", =>
        @assert.equal "", errorMessage.style.getPropertyValue "display"
        callback()
