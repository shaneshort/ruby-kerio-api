module Kerio
	module Api
		class Error < StandardError

			attr_reader :resp

			def initialize resp
				@resp = resp
			end

			def headers
				return @resp.headers
			end

			def code
				return @resp.code
			end

			def to_s
				s = "Http code: #{code}"

				if not @resp["jsonrpc"].nil?
					s += ", json-rpc message: #{@resp["error"]["message"]}"
				end

				return s
			end
		end
	end
end
