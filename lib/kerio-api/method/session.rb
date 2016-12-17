
module Kerio
	module Api
		module Method
			class Session < Kerio::Api::Method::Generic

				# we need special implementation of login method to remember the token
				def login(args)
					@names.push('login')

					@args = args
					invoke_method

					@session.token = @resp['result']['token']

					return self
				end
			end
		end
	end
end
