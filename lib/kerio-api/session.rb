require 'json'
require 'httmultiparty'
require 'httparty'
require 'kerio-api/error'
require 'uri'

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
				headers = {}
				headers['X-Token'] = @token if not @token.nil?
				headers['Cookie'] = @cookie if not @cookie.nil?

				headers
			end

			def process_json_response(resp)
				@cookie = resp.headers['Set-Cookie'] if not resp.headers['Set-Cookie'].nil?

				raise Kerio::Api::Error.new(resp, headers) if ((not resp["error"].nil?) || (resp.code != 200))
			end

			def json_method(name, params)

				h = headers
				h['Accept'] = 'application/json-rpc'

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
					headers: h,
					verify: false,
					follow_redirects: true,
				)

				process_json_response(resp)
				return resp
			end

			def upload_file(file)
				h = headers
				h['Accept'] = '*/*'
				h['Content-Type'] = 'multipart/form-data';

				resp = HTTMultiParty.post(
					@url.to_s + '/upload',
					headers: h,
					verify: false,
					query: {
						'newFile.bin' => file,
					}
				)

				process_json_response(resp)
				return resp
			end

			def download_file(path)
				h = headers
				h['Accept'] = '*/*'

				u = URI.parse("#{@url.scheme}://#{@url.host}:#{@url.port}#{path}")

				resp = HTTParty.get(
					u.to_s,
					headers: h,
					verify: false,
					stream_body: true,
				) do |fragment|
					yield fragment
				end

				raise Kerio::Api::Error.new(resp, headers) if resp.code != 200

				return {"result" => {"code" => resp.code}}
			end
		end
	end
end
