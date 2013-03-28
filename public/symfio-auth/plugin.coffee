SymfioAuth = angular.module "SymfioAuth", ["ngCookies"]

class SymfioAuthConfigs
  constructor: (@defaults={}, @configs={}) ->

  set: (name, value) =>
    if name instanceof Object
      $.extend @configs, name
    else
      @configs[name] = value

  get: (name, defaultValue) =>
    @configs[name] or @defaults[name] or defaultValue

  $get: =>
    @

  all: =>
    $.extend {}, @defaults, @configs


SymfioAuth.factory "user", ($http, $cookieStore) ->
  setToken = (token) ->
    $http.defaults.headers.common.Authorization = "Token #{token}"

  if $cookieStore.get "username" and $cookieStore.get "token"
    promise = $http.get("/sessions/#{$cookieStore.get "token"}")
    promise.success (data, status) ->
      setToken $cookieStore.get "token" if status is 200
      $cookieStore.remove "token" if status is 404

  isAuthenticated: ->
    $cookieStore.get("token")?

  getUsername: ->
    $cookieStore.get "username"

  logout: ->
    $cookieStore.remove "username"
    $cookieStore.remove "token"

  auth: (username, password, callback) ->
    body    = username: username, password: password
    promise = $http.post("/sessions", body)
    promise.success (auth, status) ->
      $cookieStore.put "username", username
      $cookieStore.put "token", auth.token if auth.token
      setToken auth.token
      callback(auth.token) if callback
    promise.error ->
      callback()


SymfioAuth.provider "SymfioAuth", ->
  new SymfioAuthConfigs
    template: "symfio-auth/template.html"
    loginText: "Username"
    passwordText: "Password"
    buttonText: "Send"
    showPlaceholders: false
    errorMessage: "Username or password invalid"


SymfioAuth.directive "symfioAuth", (SymfioAuth, user) ->
  scope: {}
  restrict: "EACM"
  template: "<ng-include src='template'></ng-include>"
  link: (scope, element, attrs) ->
    scope.user = {}
    scope.invalid = false

    for name, value of SymfioAuth.all()
      SymfioAuth.set name, attrs[name] if attrs[name]

    $.extend scope, SymfioAuth.all()

    scope.submit = ->
      user.auth scope.user.username, scope.user.password, (auth) ->
        scope.invalid = not auth
