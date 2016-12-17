module Kerio
	module Api
		module Method
			class Generic
				def initialize (params)

					@names = params[:names]

					@session = params[:session]
				end

				def next_instance
					# prefer special implementation over the generic one

					method_class = @names.inject(Kerio::Api::Method) {|o,c| o.const_get c}
					return method_class.new(names: @names, session: @session)

				rescue NameError

					return Kerio::Api::Method::Generic.new(names: @names, session: @session)
				end

				def invoke_method

					if @resp.nil?
						name = @names.join('.')
						@resp = @session.request(name, @args)
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

					# stop instantiating if args are given
					if not args[0].nil?
						@args = args[0]
						return self
					end

					# just create next instance in the chain

					return next_instance
				end
			end
		end
	end
end

