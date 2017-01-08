#!/usr/bin/env ruby

require 'pp'
require 'kerio-api'
require 'uri'

uri = URI.parse('https://connect:4040/admin/api/jsonrpc')
#uri = URI.parse('https://localhost:4040/admin/api/jsonrpc')
kms = Kerio::Api::Client.new(url: uri, insecure: true)

pp kms.Init.setHostname(hostname: 'host-name')
pp kms.Init.createPrimaryDomain(domainName: "kurva.com")
pp kms.Init.createAdministratorAccount(loginName: "Admin", password: "passwrd")
pp kms.Init.finish()

puts "Waiting a bit"
sleep 30

pp kms.Session.login(userName: 'Admin', password: 'passwrd', application: {name: "", vendor: "", version: ""})

#pp kms.Statistics.get
#pp kms.Statistics.getCharts
#pp kms.Statistics.getChartData({classname: 'Connections', name: 'SMTP', scaleId: 4})

license_id = kms.upload('README.md')['fileUpload']['id']
pp license_id
begin
	#this fails, we don't have a valid license file
	kms.Server.uploadLicense(fileId: license_id)

rescue Kerio::Api::Error => e
	pp e.resp
end

pp kms.Session.logout

