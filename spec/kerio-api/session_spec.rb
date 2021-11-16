require 'spec_helper'
require 'kerio-api/session'
require 'uri'
require 'json'

describe Kerio::Api::Session do

	let(:session){described_class.new(URI.parse('http://xxx:4000/admin'), true, false)}

	let(:http_response_ok) do
		response = double(HTTParty::Response)
		allow(response).to receive(:code).and_return(200)
		allow(response).to receive(:headers).and_return({})
		allow(response).to receive(:[]).with('error').and_return(nil)

		response
	end

	before do
		allow(Kernel).to receive(:rand).and_return(1)
		session.instance_eval do
			@token = 'token'
			@cookie = 'cookie'
		end
	end

	describe '#json_method' do
		context 'successfull call' do

			it 'sends request' do
				stub = stub_request(:post, 'http://xxx:4000/admin').with(
					:body => "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"method\",\"params\":{\"k\":\"v\"},\"token\":\"token\"}",
					:headers => {
						'Accept'=>'application/json-rpc',
						'X-Token'=>'token',
						'Cookie'=>'cookie',
					}
				).to_return(
					status: 200,
					body: JSON.generate({"result" => 42}),
					headers: {
						'Content-Type' => 'application/json-rpc',
					}
				)

				result = session.json_method('method', {k: 'v'})

				expect(result['result']).to be 42
				expect(stub).to have_been_requested
			end

			it 'uses correct params' do

				expect(HTTParty).to receive(:post).with(
					'http://xxx:4000/admin',
					body: JSON.generate({'jsonrpc' => '2.0', 'id' => 1, 'method' => 'method', 'params' => {"result" => 42}, 'token' => 'token'}),
					headers: {"X-Token" => "token", "Cookie" => "cookie", "Accept" => "application/json-rpc", "Accept-Encoding"=>"identity"},
					verify: true,
					follow_redirects: true,
				).and_return(http_response_ok)
				session.json_method('method', {"result" => 42})
			end
		end

		context 'error response' do
			it 'error message' do
				stub = stub_request(:post, 'http://xxx:4000/admin').to_return(
					status: 200,
					body: JSON.generate({"error" => ""}),
					headers: {
						'Content-Type' => 'application/json-rpc',
					}
				)

				expect{session.json_method('method', {})}.to raise_error(Kerio::Api::Error)
			end

			it 'http error code' do
				stub = stub_request(:post, 'http://xxx:4000/admin').to_return(
					status: 400,
				)

				expect{session.json_method('method', {})}.to raise_error(Kerio::Api::Error)
			end
		end

		context 'debug mode' do
			let(:session){described_class.new(URI.parse('http://xxx:4000/admin'), true, true)}

			it 'sends request with pp call' do
				stub = stub_request(:post, 'http://xxx:4000/admin').with(
					:body => "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"method\",\"params\":{\"k\":\"v\"},\"token\":\"token\"}",
					:headers => {
						'Accept'=>'application/json-rpc',
						'X-Token'=>'token',
						'Cookie'=>'cookie',
					}
				).to_return(
					status: 200,
					body: JSON.generate({"result" => 42}),
					headers: {
						'Content-Type' => 'application/json-rpc',
					}
				)

				expect(PP).to receive(:pp).twice

				result = session.json_method('method', {k: 'v'})

				expect(result['result']).to be 42
				expect(stub).to have_been_requested
			end
		end
	end

	describe '#upload_file' do
		context 'successfull call' do

			it 'sends request' do
				stub = stub_request(:post, 'http://xxx:4000/admin/upload?newFile.bin=content').with(
					:headers => {
						'Accept'=>'*/*',
						'Accept-Encoding'=>'identity',
						'X-Token'=>'token',
						'Cookie'=>'cookie',
					}
				).to_return(
					status: 200,
					body: JSON.generate({"result" => 42}),
					headers: {
						'Content-Type' => 'application/json-rpc',
					}
				)

				result = session.upload_file('content')

				expect(result['result']).to be 42
				expect(stub).to have_been_requested
			end

			it 'uses correct params' do

				expect(HTTParty).to receive(:post).with(
					'http://xxx:4000/admin/upload',
					headers: {"X-Token" => "token", "Cookie" => "cookie", "Accept" => "*/*", "Content-Type" => "multipart/form-data", "Accept-Encoding"=>"identity"},
					verify: true,
					query: {'newFile.bin' => 'content'},
					follow_redirects: true,
				).and_return(http_response_ok)
				session.upload_file('content')
			end
		end

		context 'error response' do
			it 'error message' do
				stub = stub_request(:post, 'http://xxx:4000/admin/upload').to_return(
					status: 200,
					body: JSON.generate({"error" => ""}),
					headers: {
						'Content-Type' => 'application/json-rpc',
					}
				)

				expect{session.upload_file('content')}.to raise_error(Kerio::Api::Error)
			end

			it 'http error code' do
				stub = stub_request(:post, 'http://xxx:4000/admin/upload').to_return(
					status: 400,
				)

				expect{session.upload_file('content')}.to raise_error(Kerio::Api::Error)
			end
		end
	end

	describe '#download_file' do
		it 'uses correct params' do

			expect(HTTParty).to receive(:get).with(
				'http://xxx:4000/file',
				headers: {"X-Token" => "token", "Cookie" => "cookie", "Accept" => "*/*", "Accept-Encoding"=>"identity"},
				verify: true,
				follow_redirects: true,
				stream_body: true
			).and_return(http_response_ok)

			session.download_file('/file'){|f|}
		end

	end
end
