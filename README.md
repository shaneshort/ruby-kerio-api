kerio-api
=========
[![Gem Version](https://badge.fury.io/rb/kerio-api.svg)](https://badge.fury.io/rb/kerio-api)

Ruby library that allows simple access to Kerio Technolgies products administration API (Control, Connect, Operator).

Usage
-----

Kerio products implement API based on json-rpc protocol. Methods are grouped to interfaces and their names follow **Interface.method** convention. This API simulates an object-like interface following that convention.

Interfaces and methods itself are documented at [Kerio website](http://www.kerio.com/learn-community/developer-zone/details).

Examples
--------

### Print some Kerio Connect statistics
```
require 'kerio-api'
require 'uri'

mailserver = Kerio::Api::Client.new(url: URI.parse('https://localhost:4040/admin/api/jsonrpc/'))

mailserver.Session.login(
	userName: 'Admin',
	password: 'pwd',
	application: {name: "my app", vendor: "me", version: "current"}
)

pp mailserver.Statistics.getChartData({classname: 'Connections', name: 'SMTP', scaleId: 4})

mailserver.Session.logout
```

### Register fresh new instance of Operator
```
operator = Kerio::Api::Client.new(url: URI.parse('https://localhost:4021/admin/api/jsonrpc/'))

operator.ProductActivation.activate(
       adminPassword: "pwd",
       adminLanguage: "en",
       adminEmail: "admin@my.company.net",
       pbxLanguageId: 2,
       pbxStartingNumber: "10",
       timeZoneId: "",
       reboot: false,
       sendClientStatistics: false,
       myKerioEnabled: false,
)

operator.Session.login(userName: 'Admin', password: 'pwd', application: {name: "my app", vendor: "me", version: "current"})
operator.Session.logout
```

### Print Control product information
```
winroute = Kerio::Api::Client.new(url: URI.parse('https://localhost:4081/admin/api/jsonrpc/'))
winroute.Session.login(
	serName: 'Admin',
	assword: 'pwd',
	application: {name: "", vendor: "", version: ""}
)

pp winroute.ProductInfo.get
winroute.Session.logout

```

