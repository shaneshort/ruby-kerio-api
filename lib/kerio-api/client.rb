require 'kerio-api/session'
require 'kerio-api/chainable_method'
require 'kerio-api/method/generic'

module Kerio
	module Api
		class Client
			include Kerio::Api::ChainableMethod

			def initialize (params)

				verify_ssl = true
				verify_ssl = !params[:insecure] if not params[:insecure].nil?

				@session = Kerio::Api::Session.new(params[:url], verify_ssl)
			end

			def method_missing(method, *args, &block)
				return next_method(names: [method], session: @session, args: args, block: block)
			end
		end
	end
end
