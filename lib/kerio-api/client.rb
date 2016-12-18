require 'kerio-api/session'
require 'kerio-api/chainable_method'
require 'kerio-api/method/generic'
require 'kerio-api/method/session/login'
require 'kerio-api/method/upload'

module Kerio
	module Api
		class Client
			include Kerio::Api::ChainableMethod

			def initialize (params)
				@session = Kerio::Api::Session.new(params[:url])
			end

			def method_missing(method, *args, &block)
				return next_method(names: [method], session: @session, args: args)
			end
		end
	end
end
