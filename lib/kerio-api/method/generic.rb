module Kerio
	module Api
		module Method
			class Generic
				include Kerio::Api::ChainableMethod

				def initialize (params)

					@names = params[:names]

					@session = params[:session]

					@args = params[:args]
				end

				def invoke_method
					if @resp.nil?
						name = @names.join('.')
						@resp = @session.json_method(name, @args[0])
					end
				end

				def result
					invoke_method
					return @resp['result']
				end

				def [](index)
					return result[index]
				end

				def method_missing(method, *args, &block)

					@names.push(method)

					return next_method(names: @names, session: @session, args: args)
				end
			end
		end
	end
end

