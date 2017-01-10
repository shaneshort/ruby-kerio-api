require 'kerio-api'
require 'uri'

uri = URI.parse($api)
kwf = Kerio::Api::Client.new(url: uri, insecure: true)

describe 'control' do

	# we expect already initialized instance of control
	it 'logs in' do
		expect(kwf.Session.login(userName: 'Admin', password: 'kurva', application: {name: "", vendor: "", version: ""}).__result).to include("token")
	end

	it 'uploads license' do
		license_id = kwf.upload('README.md')['fileUpload']['id']
		expect{kwf.ProductInfo.uploadLicense(fileId: license_id)}.to raise_error(Kerio::Api::Error)
	end

	it 'logs out' do
		expect(kwf.Session.logout().__result).to be_instance_of Hash
	end

	it 'fails to log out again' do
		expect{kwf.Session.logout().__result}.to raise_error Kerio::Api::Error
	end
end
