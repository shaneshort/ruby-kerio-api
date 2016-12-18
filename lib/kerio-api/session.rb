require 'json'
require 'httmultiparty'
require 'kerio-api/error'

module Kerio
	module Api
		class Session
			attr_writer :token

			def initialize(url)
				@url = url

				@token = nil
				@cookie = nil
			end

			def headers
				headers = {
					'Accept' => 'application/json-rpc',
				}
				headers['X-Token'] = @token if not @token.nil?
				headers['Cookie'] = @cookie if not @cookie.nil?

				headers
			end

			def json_method(name, params)

				body = {
					jsonrpc: '2.0',
					id: Kernel.rand(10**12),
					method: name,
					params: params,
				}
				body['token'] = @token if not @token.nil?

				resp = HTTMultiParty.post(
					@url.to_s,
					body: JSON.generate(body),
					headers: headers,
					verify: false,
					follow_redirects: true,
				)
				@cookie = resp.headers['Set-Cookie'] if not resp.headers['Set-Cookie'].nil?

				raise Kerio::Api::Error.new(resp, headers) if not resp["error"].nil?

				return resp
			end
		end
	end
end
