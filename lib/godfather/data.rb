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
        check_strict!(key, val)

        block = dsl_block(key, val)
        obj[key] = block ? block.call(@params.to_options) : val
      end
    end

    def dsl_block(key, val)
      dsl_key(key).andand[val]
    end

    def dsl_key(key)
      @controller.class.dsls.andand[key]
    end

    def check_strict!(key, val)
      return unless dsl_key(key)
      return unless strict?(key) and !dsl_block(key, val)

      raise NotPermittedError, "DSL column '#{key}' received unmatched string '#{val}'." \
        " Use 'strict: false' in DSL definition to allow everything."
    end

    def strict?(key)
      @controller.class.stricts.andand[key]
    end
  end
end
