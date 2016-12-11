module Kerio
	module Api
		module Interface
			class Generic
				def initialize (name, session)
					@name = name
					@session = session
				end

				def method_missing(method, *args, &block)
					return @session.request("#{@name}.#{method}", args[0])
				end
			end
		end
	end
end
