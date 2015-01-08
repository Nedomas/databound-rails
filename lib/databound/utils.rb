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

  class Utils
    def self.databound_to_application_controller!
      def ApplicationController.databound(model = nil, &block)
        include Databound

        send(:define_method, :databound_config) do
          Databound::Config.new(block, model)
        end
      end
    end

    def self.create_controller_unless_exists(path, resource, opts)
      return if exists?(path)
      opts ||= {}
      model_name = opts.delete(:model) || fallback_model(resource)

      controller = Class.new(ApplicationController)
      controller.send(:databound) do
        opts.each do |name, value|
          model model_name
          send(name, *value)
        end
      end

      Object.const_set(controller_name(path), controller)
    end

    def self.fallback_model(resource)
      resource.to_s.classify.underscore
    end

    def self.exists?(path)
      name_error = false

      begin
        controller_name(path).constantize
      rescue NameError
        name_error = true
      end

      !name_error
    end

    def self.controller_name(path)
      "#{path.camelize}Controller"
    end
  end
end
