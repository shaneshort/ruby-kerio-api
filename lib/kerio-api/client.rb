require 'kerio-api/session'
require 'kerio-api/interface'

module Kerio
	module Api
		class Client
			def initialize (params)

				@session = Kerio::Api::Session.new(params[:url])

				@session.login(params[:user], params[:password])
			end

			def method_missing(method, *args, &block)
				return Kerio::Api::Interface.new(method, @session)
			end
		end
	end
end
