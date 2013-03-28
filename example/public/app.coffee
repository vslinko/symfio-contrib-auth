window.authExampleApp = angular.module "AuthExampleApp", [
  "SymfioAuth"
]

authExampleApp.config (SymfioAuthProvider) ->
  SymfioAuthProvider.$get().set
    loginText: "Login text from config provider"