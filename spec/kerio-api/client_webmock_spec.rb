require 'spec_helper'
require 'uri'
require 'kerio-api'

describe 'kerio-api' do
	before do
		allow(Kernel).to receive(:rand).and_return(1)
	end

	context 'successful request' do

		it 'logs in and calls some method' do
			stub_request(:post, "http://xxxxxx:3000/admin").
				with(
					:body => "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"Session.login\",\"params\":{\"userName\":\"u\",\"password\":\"p\",\"application\":{\"name\":\"\",\"vendor\":\"\",\"version\":\"\"}},\"token\":null}",
					:headers => {'Accept'=>'application/json-rpc'}).
				to_return(
					status: 200,
					body: JSON.generate({"result" => {"token": 'secret'}}),
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
					body: JSON.generate({"result" => 42}),
					headers: {
						'Content-Type' => 'application/json-rpc',
					}
				)

			expect(client.Interface.meth({a: 'b'})).to eq 42
		end
	end

	context 'error response' do
		it 'raises error' do

			client = Kerio::Api::Client.new(url: URI.parse('http://xxxxxx:3000/admin'))

			stub_request(:post, "http://xxxxxx:3000/admin").
				with(
					:body => "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"Interface.meth\",\"params\":{\"a\":\"b\"},\"token\":null}",
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

			expect{client.Interface.meth({a: 'b'})}.to raise_error(Kerio::Api::Error)
		end
	end
end
