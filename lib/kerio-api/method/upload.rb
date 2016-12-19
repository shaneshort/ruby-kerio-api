require 'json'

module Kerio
	module Api
		module Method
			class Upload < Kerio::Api::Method::Generic

				def __invoke_method
					if @resp.nil?
						raw = @session.upload_file(File.new(@args[0]))

						@resp = JSON.parse(raw)
					end
				end
			end
		end
	end
end
