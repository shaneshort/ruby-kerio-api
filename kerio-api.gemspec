Gem::Specification.new do |s|
	s.name        = 'kerio-api'
	s.version     = '1.0.0'
	s.date        = '2017-01-17'
	s.summary     = "Client library to access administration API of Kerio products"
	s.description = "This gem allows simple access to administration API of Kerio products"
	s.authors     = ["Petr Baloun"]
	s.email       = 'balounp@gmail.com'
	s.files       = [
		"lib/kerio-api.rb",
		"lib/kerio-api/client.rb",
		"lib/kerio-api/error.rb",
		"lib/kerio-api/session.rb",
		"lib/kerio-api/chainable_method.rb",
		"lib/kerio-api/method/generic.rb",
		"lib/kerio-api/method/download.rb",
		"lib/kerio-api/method/upload.rb",
		"lib/kerio-api/method/session/login.rb",
	]
	s.homepage    = 'https://github.com/balous/ruby-kerio-api'
	s.license     = 'MIT'

	s.add_runtime_dependency 'httmultiparty', '~> 0.3.16'
	s.add_runtime_dependency 'httparty', '~> 0.14.0'
	s.add_runtime_dependency 'json_pure', '~> 2.0.2'

	s.add_development_dependency 'rspec', '~> 3.5'
	s.add_development_dependency 'webmock', '~> 2.3.1'
	s.add_development_dependency 'bundler', '~> 1.12'
	s.add_development_dependency 'yard', '~> 0.9.5'
	s.add_development_dependency 'rake', '~> 10.0.0'
	s.add_development_dependency 'simplecov', '~> 0.12.0'
end
