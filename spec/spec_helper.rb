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
  convert_records(optionize(JSON.parse(response.body)))
end

def optionize(obj)
  case obj
  when Array
    obj.map(&:to_options)
  else
    obj.to_options
  end
end

def convert_records(data)
  return data unless data.is_a?(Hash)

  %i(records scoped_records).each_with_object(data) do |type, obj|
    next unless data[type]

    obj[type] = JSON.parse(data[type]).map do |r|
      r.except('created_at', 'updated_at')
    end
  end
end

def gather(collection, attribute, response)
  rubize(response)[collection].map { |record| record.to_options[attribute] }
end

def all_records(model = User)
  model.select(:id, :name, :city).map(&:attributes)
end

def assert_responses(code, error, msg)
  friendly_handler = controller.class.rescue_handlers.first.last

  controller.class.rescue_from(error) { raise error, msg }
  expect(code).to raise_error(error, msg)

  # check friendly handler
  controller.class.rescue_from(error, with: friendly_handler)
  code.call

  expect(response.status).to eq(error::STATUS)
  expect(rubize(response)).to eq(
    message: msg,
  )
end
