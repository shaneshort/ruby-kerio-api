module Kerio
	module Api
		module Method
			class Upload < Kerio::Api::Method::Generic

				def invoke_method
					@resp = {'result' => @args[0]}
				end
			end
		end
	end
end
