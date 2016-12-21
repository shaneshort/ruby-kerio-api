module Kerio
	module Api
		module Method
			class Generic
				include Kerio::Api::ChainableMethod

				def initialize (params)

					@names = params[:names]

					@session = params[:session]

					@args = params[:args]

					@block = params[:block]

					__invoke_method if @args.count > 0
				end

				def __invoke_method
					if @resp.nil?
						name = @names.join('.')
						@resp = @session.json_method(name, @args[0])
					end
				end

				def __result
					__invoke_method
					return @resp['result']
				end

				def [](index)
					return __result[index]
				end

				def pretty_print pp
					pp __result
				end

				def method_missing(method, *args, &block)

					@names.push(method)

					return next_method(names: @names, session: @session, args: args)
				end
			end
		end
	end
end

