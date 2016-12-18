module Kerio
	module Api
		module Method
			module Session 
				class Logout < Kerio::Api::Method::Generic

					#make sure the method is invoked immediately
					def initialize(params)
						super
						__invoke_method
					end
				end
			end
		end
	end
end
