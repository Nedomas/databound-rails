module Godfather
  class Data
    def initialize(controller, json)
      return unless json

      @controller = controller
      @params = JSON.parse(json) if json.is_a?(String)
      @params = json if json.is_a?(Hash)
      @data = interpolated_params
    end

    def records(model)
      model.where(@data)
    end

    def to_h
      @data
    end

    private

    def interpolated_params
      @params.each_with_object({}) do |(key, val), obj|
        dsl_block = @controller.class.dsls[key].andand[val]
        obj[key] = dsl_block ? dsl_block.call(@params) : val
      end
    end
  end
end
