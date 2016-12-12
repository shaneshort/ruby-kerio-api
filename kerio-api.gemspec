Gem::Specification.new do |s|
	s.name        = 'kerio-api'
	s.version     = '0.1.0'
	s.date        = '2016-12-11'
	s.summary     = "Client library to access administration API of Kerio products"
	s.description = "This gem allows simple access to administration API of Kerio products"
	s.authors     = ["Petr Baloun"]
	s.email       = 'balounp@gmail.com'
	s.files       = [
		"lib/kerio-api.rb",
		"lib/kerio-api/client.rb",
		"lib/kerio-api/error.rb",
		"lib/kerio-api/session.rb",
		"lib/kerio-api/interface/generic.rb",
		"lib/kerio-api/interface/session.rb",
	]
	s.homepage    = 'https://github.com/balous/ruby-kerio-api'
	s.license     = 'MIT'

	s.add_runtime_dependency 'httparty', '~> 0.14'
	s.add_runtime_dependency 'json', '~> 2'

	s.add_development_dependency 'rspec', '~> 3'
	s.add_development_dependency 'webmock', '~> 0'
	s.add_development_dependency 'bundler', '~> 0'
end
