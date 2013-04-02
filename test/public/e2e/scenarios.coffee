
describe "contrib-auth plugin example", ->

  beforeEach ->
    browser().navigateTo "/"

  it "should find auth form fields", ->
    expect(element("input[name='username']").count()).toEqual 1
    expect(element("input[name='password']").count()).toEqual 1

  it "should login text configured from provider", ->
    expect(element(".symfio-auth-login-text label").text())
      .toEqual "Login text from config provider"

  it "should password text configured from attrs", ->
    expect(element(".symfio-auth-password-text label").text())
      .toEqual "Password text from attrs"

  it "should show error message when invalid", ->
    expect(element(".symfio-auth-error-message").css "display").toEqual "none"

    input("user.username").enter "invalid"
    input("user.password").enter "invalid"

    element(":button").click()

    expect(element(".symfio-auth-error-message").css "display").toEqual "block"

  it "should auth user and populate token in cookies", ->
    input("user.username").enter "username"
    input("user.password").enter "password"

    element(":button").click()

    expect(element(".symfio-auth-error-message").css "display").toEqual "none"
