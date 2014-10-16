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
  optionize(JSON.parse(response.body))
end

def optionize(obj)
  case obj
  when Array
    obj.map(&:to_options)
  else
    obj.to_options
  end
end

def gather(attribute, response)
  rubize(response).map { |record| record[attribute] }
end
