require 'json'
require 'httparty'
require 'kerio-api/error'

module Kerio
	module Api
		class Session

			def initialize(url)
				@url = url

				@token = nil
				@cookie = nil
			end

			def request(method, params)
				body = JSON.generate({
					jsonrpc: '2.0',
					id: rand(10**12),
					method: method,
					params: params,
					token: @token,
				})

				headers = {
					'Accept' => 'application/json-rpc',
				}
				headers['X-Token'] = @token if not @token.nil?
				headers['Cookie'] = @cookie if not @cookie.nil?

				resp = HTTParty.post(
					@url.to_s,
					body: body,
					headers: headers,
					verify: false,
					follow_redirects: true,
				)

				@cookie = resp.headers['Set-Cookie'] if not resp.headers['Set-Cookie'].nil?

				raise Kerio::Api::Error.new(resp, headers) if not resp["error"].nil?

				return resp["result"]
			end

			def login(user, pass)
				result = request(
					'Session.login',
					{
						userName: user,
						password: pass,
						application: {name: "", vendor: "", version: ""},
					}
				)

				@token = result['token']
			end
		end
	end
end
