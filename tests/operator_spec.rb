require 'kerio-api'
require 'uri'

uri = URI.parse($api)
operator = Kerio::Api::Client.new(url: uri, insecure: true)

password = 'ppppp'

describe 'operator' do

	it 'initializes operator' do
		expect(
			operator.ProductActivation.activate(
				adminPassword: password,
				adminLanguage: "en",
				adminEmail: "root@kurva.xxx",
				pbxLanguageId: 2,
				pbxStartingNumber: "10",
				timeZoneId: "",
				reboot: false,
				sendClientStatistics: false,
				myKerioEnabled: false,
			).__result
		).to be_instance_of Hash
	end

	it 'logs in' do
		expect(operator.Session.login(userName: 'Admin', password: password, application: {name: "", vendor: "", version: ""}).__result).to include("token")
	end

	it 'uploads license' do
		license_id = operator.upload('README.md')['fileUpload']['id']
		expect{operator.Server.uploadLicense(fileId: license_id)}.to raise_error(Kerio::Api::Error)
	end

	it 'downloads backup' do
		expect(operator.SystemBackup.backupCancel.__result).to be_instance_of Hash
		expect(
			operator.SystemBackup.backupStart(
				sections: {
					SYSTEM_DATABASE: true,
					VOICE_MAIL: true,
					SYSTEM_LOG: true,
					CALL_LOG: true,
					LICENSE: true,
					RECORDED_CALLS: true,
					TFTP: true
				}
			).__result
		).to be_instance_of Hash

		while true do
			break if (operator.SystemBackup.get['statusBackup']['STATE']) != 1
			sleep 1
		end

		backup = operator.SystemBackup.backupDownload["fileDownload"]

		expect(operator.download(backup["url"]) {|fragment|})
	end

	it 'logs out' do
		expect(operator.Session.logout().__result).to be_instance_of Hash
	end

	it 'fails to log out again' do
		expect{operator.Session.logout().__result}.to raise_error(Kerio::Api::Error)
	end
end
