# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rack/stripper', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Benjamin Kreeger']
  gem.email         = ['ben@kree.gr']
  gem.description   = 'Trims whitespace from response bodies sent through rack.'
  gem.summary       = 'Trims whitespace from response bodies sent through rack.'
  gem.homepage      = 'http://github.com/kreeger/rack-stripper'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'rack-stripper'
  gem.require_paths = ['lib']
  gem.version       = Rack::Stripper::VERSION

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'debugger'
  gem.add_runtime_dependency 'rack', '~> 1.4.5'
end
