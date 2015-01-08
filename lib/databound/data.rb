module Databound
  class Data
    def initialize(controller, json, model)
      return unless json

      @controller = controller
      @json = json
      @data = interpolated_params
      @model = model
    end

    def records
      @model.where(@data)
    end

    def to_h
      @data
    end

    private

    def params
      @params ||= JSON.parse(@json) if @json.is_a?(String)
      @params ||= @json if @json.is_a?(Hash)
      OpenStruct.new(@params)
    end

    def interpolated_params
      params.to_h.each_with_object({}) do |(key, val), obj|
        check_strict!(key, val)

        block = dsl_block(key, val)
        obj[key] = block ? @controller.instance_exec(params, &block) : val
      end
    end

    def dsl_block(key, val)
      swallow_nil { dsl_key(key)[val.to_s] }
    end

    def dsl_key(key)
      swallow_nil { @controller.databound_config.read(:dsls)[key] }
    end

    def check_strict!(key, val)
      return unless dsl_key(key)
      return unless strict?(key) and !dsl_block(key, val)

      raise NotPermittedError, "DSL column '#{key}' received unmatched string '#{val}'." \
        " Use 'strict: false' in DSL definition to allow everything."
    end

    def strict?(key)
      swallow_nil { @controller.databound_config.read(:stricts)[key] }
    end
  end
end
