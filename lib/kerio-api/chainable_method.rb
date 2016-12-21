module Kerio
	module Api
		module ChainableMethod
			def next_method(params)

				# prefer special implementation over the generic one
				begin
					source = "kerio-api/method/#{params[:names].join('/')}.rb".downcase
					require source

					method_class = params[:names].inject(Kerio::Api::Method) {|o,c| o.const_get c.capitalize}
					method_instance = method_class.new(params)

				rescue NameError, LoadError
					method_instance = Kerio::Api::Method::Generic.new(params)
				end

				return method_instance
			end
		end
	end
end
