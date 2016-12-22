module Kerio
	module Api
		class Error < StandardError

			# Returns HTTP response as returned by used http library
			attr_reader :resp

			def initialize resp
				@resp = resp
			end

			# Returns HTTP headers returned by the server
			def headers
				return @resp.headers
			end

			# Returns HTTP code returned by the server
			def code
				return @resp.code
			end

			# Formats human readable error message
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
