module Kerio
	module Api
		class Error < StandardError

			attr_reader :resp, :headers

			def initialize resp, headers
				@resp = resp
				@headers = headers
			end

			def to_s
				return @resp["error"]["message"]
			end
		end
	end
end
