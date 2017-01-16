require 'kerio-api'
require 'uri'

uri = URI.parse($api)
kms = Kerio::Api::Client.new(url: uri, insecure: true)

password = 'ppppp'

describe 'connect' do

	before 'Wait for connect to start' do
		while not test_port(uri.host, uri.port)
			sleep 1
		end
	end

	describe 'initialize' do
		it 'initializes connect' do
			expect(kms.Init.setHostname(hostname: 'host-name').__result).to be_instance_of Hash
			expect(kms.Init.createPrimaryDomain(domainName: "domain.com").__result).to be_instance_of Hash
			expect(kms.Init.createAdministratorAccount(loginName: "Admin", password: password).__result).to be_instance_of Hash
			expect(kms.Init.finish.__result).to be_instance_of Hash
		end

		# connect needs some time after init
		after 'Wait for connect restart' do
			while true do
				begin
					kms.Session.login(userName: 'Admin', password: password, application: {name: "", vendor: "", version: ""})
					break
				rescue Kerio::Api::Error, Errno::ECONNRESET, Errno::ECONNREFUSED
					sleep 1
				end
			end
		end
	end

	describe 'authenticated actions' do
		it 'logs in' do
			expect(kms.Session.login(userName: 'Admin', password: password, application: {name: "", vendor: "", version: ""}).__result).to include("token")
		end

		it 'uploads license' do
			license_id = kms.upload('README.md')['fileUpload']['id']
			expect{kms.Server.uploadLicense(fileId: license_id)}.to raise_error(Kerio::Api::Error)
		end

		it 'logs out' do
			expect(kms.Session.logout().__result).to be_instance_of Hash
		end

		it 'fails to log out again' do
			expect{kms.Session.logout().__result}.to raise_error(Kerio::Api::Error)
		end
	end
end
