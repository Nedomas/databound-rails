module Databound
  class Config
    def initialize(block, model)
      @model = model
      @permit = {}
      instance_eval(&block)
    end

    def columns(*specified_columns)
      @columns = specified_columns
    end

    def model(specified_model)
      raise "Model '#{@model}' already specified" if @model

      @model = specified_model
    end

    def permit(*methods, &block)
      methods.each do |method|
        @permit[method] = block
      end
    end

    def dsl(name, value, strict: true, &block)
      @stricts ||= {}
      @stricts[name] = strict

      @dsls ||= {}
      @dsls[name] ||= {}
      @dsls[name][value.to_s] = block
    end

    def read(name)
      instance_variable_get("@#{name}")
    end
  end
end
