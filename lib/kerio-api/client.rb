require 'kerio-api/session'
require 'kerio-api/method/generic'
require 'kerio-api/method/session'

module Kerio
	module Api
		class Client
			def initialize (params)

				@session = Kerio::Api::Session.new(params[:url])
			end

			def method_missing(method, *args, &block)

				return Kerio::Api::Method::Generic.new(names: [], session: @session).send(method, args[0])
			end
		end
	end
end
