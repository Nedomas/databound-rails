require 'rubygems'
require 'bundler/setup'

require 'combustion'

Combustion.initialize! :all

require 'rspec/rails'
require 'pry'

RSpec.configure do |config|
  config.use_transactional_fixtures = true
end

def javascriptize(ruby_obj)
  ruby_obj.each_with_object({}) do |(key, val), obj|
    obj[key] = JSON.dump(val)
  end
end

def rubize(response)
  JSON.parse(response.body).to_options
end
