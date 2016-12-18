module Kerio
	module Api
		module Method
			module Session 
				class Login < Kerio::Api::Method::Generic

					def initialize(params)
						super
						invoke_method
					end
			
					# we need special implementation of login method to remember the token
					def invoke_method

						super
						@session.token = @resp['result']['token']
					end
				end
			end
		end
	end
end
