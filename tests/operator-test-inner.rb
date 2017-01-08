#!/usr/bin/env ruby

require 'pp'
require 'kerio-api'
require 'uri'

uri = URI.parse('https://operator:4021/admin/api/jsonrpc')
kts = Kerio::Api::Client.new(url: uri, insecure: true)

pp kts.ProductActivation.activate(
	adminPassword: "kurva",
	adminLanguage: "en",
	adminEmail: "root@kurva.xxx",
	pbxLanguageId: 2,
	pbxStartingNumber: "10",
	timeZoneId: "",
	reboot: false,
	sendClientStatistics: false,
	myKerioEnabled: false,
)

pp kts.Session.login(userName: 'Admin', password: 'kurva', application: {name: "", vendor: "", version: ""})

begin
	license_id = kts.upload('README.md')['fileUpload']['id']

	pp kts.Server.uploadLicense(fileId: license_id)
rescue Kerio::Api::Error => e
	pp e
end

pp kts.SystemBackup.backupCancel
pp kts.SystemBackup.backupStart(
	sections: {
	SYSTEM_DATABASE: true,
		VOICE_MAIL: true,
		SYSTEM_LOG: true,
		CALL_LOG: true,
		LICENSE: true,
		RECORDED_CALLS: true,
		TFTP: true
	}
)
while true do
	break if (pp kts.SystemBackup.get['statusBackup']['STATE']) != 1
	sleep 1
end
backup = kts.SystemBackup.backupDownload["fileDownload"]

pp backup
File.open("/tmp/#{backup["name"]}", "w") do |file|
	resp = kts.download(backup["url"]) do |fragment|
		file.write(fragment)
	end
pp resp
end

kts.Session.logout

begin
	kts.Session.logout
rescue Kerio::Api::Error => e
	pp e
end
