module Godfather
  class Data
    def initialize(controller, json)
      @controller = controller

      return unless json
      hash = JSON.parse(json) if json.is_a?(String)
      hash = json if json.is_a?(Hash)
      @data = with_overrides(hash)
    end

    def records(model)
      model.where(@data)
    end

    def to_h
      @data
    end

    private

    def with_overrides(hash)
      result = {}

      hash.each do |key, val|
        result[key] = @controller.send(:override!, key.to_sym, val, hash)
      end

      result
    end
  end
end
