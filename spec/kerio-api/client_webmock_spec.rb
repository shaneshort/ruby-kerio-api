require 'spec_helper'
require 'uri'
require 'kerio-api'

def stub_json_request(method_name, params, result)
	return stub_request(:post, "http://xxxxxx:3000/admin").
		with(
			:body => JSON.generate("jsonrpc" => "2.0", "id" => 1, "method" => method_name, "params" => params),
			:headers => {'Accept'=>'application/json-rpc'},
		).
		to_return(
			status: 200,
			body: JSON.generate({"result" => result}),
			headers: {'Content-Type' => 'application/json-rpc'},
		)
end

describe 'kerio-api' do
	before do
		allow(Kernel).to receive(:rand).and_return(1)
	end

	context 'login and request' do

		it 'logs in and calls some method' do
			stub_request(:post, "http://xxxxxx:3000/admin").
				with(
					:body => "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"Session.login\",\"params\":{\"userName\":\"u\",\"password\":\"p\",\"application\":{\"name\":\"\",\"vendor\":\"\",\"version\":\"\"}}}",
					:headers => {'Accept'=>'application/json-rpc'}
				).
				to_return(
					status: 200,
					body: JSON.generate({"result" => {"token" => 'secret'}}),
					headers: {
						'Content-Type' => 'application/json-rpc',
						'Set-Cookie' => 'sekret',
					}
				)

			client = Kerio::Api::Client.new(url: URI.parse('http://xxxxxx:3000/admin'))
			client.Session.login(userName: 'u', password: 'p', application: {name: "", vendor: "", version: ""})

			stub_request(:post, "http://xxxxxx:3000/admin").
				with(
					:body => "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"Interface.meth\",\"params\":{\"a\":\"b\"},\"token\":\"secret\"}",
					:headers => {
						'Accept' => 'application/json-rpc',
						'X-Token' => 'secret',
						'Cookie' => 'sekret',
					}
				).
				to_return(
					status: 200,
					body: JSON.generate({ "jsonrpc" => "2.0", "id" => 1, "result" => 42}),
					headers: {
						'Content-Type' => 'application/json-rpc',
					}
				)

			expect(client.Interface.meth({a: 'b'}).__result).to eq 42
		end
	end

	context 'upload' do
		it 'calls the method' do
			stub_request(:post, "http://xxxxxx:3000/admin/upload").
				with(
					:headers => {
						'Accept' => '*/*',
						'Content-Type' => 'multipart/form-data; boundary=-----------RubyMultipartPost'
					}
				).
				to_return(
					:status => 200,
					:body => JSON.generate({ "jsonrpc" => "2.0", "id" => 1, "result" => 42}),
					:headers => {}
				)
			client = Kerio::Api::Client.new(url: URI.parse('http://xxxxxx:3000/admin'))
			expect(client.upload(__FILE__).__result).to eq 42
		end
	end

	context 'logout' do
		it 'calls logout' do
			logout_req = stub_json_request("Session.logout", nil, {})

			client = Kerio::Api::Client.new(url: URI.parse('http://xxxxxx:3000/admin'))
			client.Session.logout()

			expect(logout_req).to have_been_requested
		end
	end

	context 'single level method name' do
		it 'calls the method' do

			stub_json_request("xxx", {"a" => "b"}, 42)
			client = Kerio::Api::Client.new(url: URI.parse('http://xxxxxx:3000/admin'))
			expect(client.xxx({'a' => 'b'}).__result).to eq 42
		end
	end

	context 'four levels in method name' do
		it 'calls the method' do
			stub_json_request("xxx.yyy.zzz.qqq", {"a" => "b"}, 42)
			client = Kerio::Api::Client.new(url: URI.parse('http://xxxxxx:3000/admin'))
			expect(client.xxx.yyy.zzz.qqq({a: 'b'}).__result).to eq 42
		end
	end

	context 'error response' do
		it 'raises error' do

			client = Kerio::Api::Client.new(url: URI.parse('http://xxxxxx:3000/admin'))

			stub_request(:post, "http://xxxxxx:3000/admin").
				with(
					:body => "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"Interface.meth\",\"params\":{\"a\":\"b\"}}",
					:headers => {
						'Accept' => 'application/json-rpc',
					}
				).
				to_return(
					status: 200,
					body: JSON.generate({"error" => "!!!!!!!!!!!!!"}),
					headers: {
						'Content-Type' => 'application/json-rpc',
					}
				)

			expect{client.Interface.meth({a: 'b'}).__result}.to raise_error(Kerio::Api::Error)
		end
	end
end
