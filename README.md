# symfio-contrib-auth

> Authentication plugin. Uses tokens.

[![Build Status](http://teamcity.rithis.com/httpAuth/app/rest/builds/buildType:id:bt15,branch:master/statusIcon?guest=1)](http://teamcity.rithis.com/viewType.html?buildTypeId=bt15&guest=1)
[![Dependency Status](https://gemnasium.com/symfio/symfio-contrib-auth.png)](https://gemnasium.com/symfio/symfio-contrib-auth)

## Usage

```coffee
symfio = require "symfio"

container = symfio "example", __dirname

loader = container.get "loader"

loader.use require "symfio-contrib-express"
loader.use require "symfio-contrib-mongoose"
loader.use require "symfio-contrib-auth"

loader.load()
```

## Required plugins

* [contrib-express](https://github.com/symfio/symfio-contrib-express)
* [contrib-mongoose](https://github.com/symfio/symfio-contrib-mongoose)

## Can be configured

* __auth token expiration period__ — Default value is `7d`.
