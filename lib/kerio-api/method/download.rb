require 'json'

module Kerio
	module Api
		module Method
			class Download < Kerio::Api::Method::Generic

				def __invoke_method
					if @resp.nil?
						@resp = @session.download_file(@args[0]) do |fragment|
							@block.call fragment
						end
					end
				end
			end
		end
	end
end
