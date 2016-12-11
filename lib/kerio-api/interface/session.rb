require 'kerio-api/interface/generic'

module Kerio
	module Api
		module Interface
			class Session < Kerio::Api::Interface::Generic

				# we need special implementation of login method to remember the token
				def login(params)

					result = @session.request(
						'Session.login',
						params,
					)

					@session.token = result['token']
				end
			end
		end
	end
end
