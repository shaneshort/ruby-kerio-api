require 'kerio-api/session'
require 'kerio-api/chainable_method'
require 'kerio-api/method/generic'

module Kerio
	module Api
		class Client
			include Kerio::Api::ChainableMethod

			# Create new instance of the client
			#
			# @param url [URL] an URL of the API endpoint
			# @param insecure [TrueClass] whether to ignore ssl verification error (true/false)
			# @param debug [TrueClass] whether to print json-rpc data sent over network
			def initialize (url: nil, insecure: false, debug: false)

				@session = Kerio::Api::Session.new(url, !insecure, debug)
			end

			def method_missing(method, *args, &block)
				return next_method(names: [method], session: @session, args: args, block: block)
			end
		end
	end
end
