# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'databound/version'

Gem::Specification.new do |spec|
  spec.name          = 'databound'
  spec.version       = Databound::VERSION
  spec.authors       = ['Domas Bitvinskas']
  spec.email         = ['domas.bitvinskas@me.com']
  spec.summary       = %q{Provides Javascript a simple API to the Ruby on Rails CRUD}
  spec.description   = %q{It lets you use methods like create, update, destroy in the Javascript while handling all the setup and providing basic security out of the box.}
  spec.homepage      = 'http://databound.me'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'combustion', '~> 0.5.2'
  spec.add_development_dependency 'rails'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-stack_explorer'
  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.0'
end
