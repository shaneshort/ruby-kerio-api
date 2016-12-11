require 'kerio-api/session'
require 'kerio-api/interface/generic'
require 'kerio-api/interface/session'

module Kerio
	module Api
		class Client
			def initialize (params)

				@session = Kerio::Api::Session.new(params[:url])
			end

			def method_missing(method, *args, &block)

				# prefer special implementation over the generic one
				return Kerio::Api::Interface.const_get(method).new(method, @session)

			rescue NameError

				return Kerio::Api::Interface::Generic.new(method, @session)
			end
		end
	end
end
