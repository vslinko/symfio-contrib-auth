# symfio-contrib-auth

> Authentication plugin. Uses tokens.

[![Build Status](http://teamcity.rithis.com/httpAuth/app/rest/builds/buildType:id:bt15,branch:master/statusIcon?guest=1)](http://teamcity.rithis.com/viewType.html?buildTypeId=bt15&guest=1)
[![Dependency Status](https://gemnasium.com/symfio/symfio-contrib-auth.png)](https://gemnasium.com/symfio/symfio-contrib-auth)

## Usage

```coffee
symfio = require "symfio"

container = symfio "example", __dirname
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
loader.use require "symfio-contrib-auth"
loader.use require "symfio-contrib-bower"

loader.load()
```

## Required plugins

* [contrib-express](https://github.com/symfio/symfio-contrib-express)
* [contrib-mongoose](https://github.com/symfio/symfio-contrib-mongoose)
* [contrib-assets](https://github.com/symfio/symfio-contrib-assets)
* [contrib-bower](https://github.com/symfio/symfio-contrib-bower)

## Can be configured

* __auth token expiration period__ — Default value is `7d`.
