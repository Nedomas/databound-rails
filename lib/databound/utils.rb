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
      return
      return if exists?(path)
      opts ||= {}

      controller = Class.new(ApplicationController)
      controller.send(:include, Databound)
      controller.send(:define_method, :model) do
        resource.to_s.classify.constantize
      end

      controller.send(:define_method, :permitted_columns) do
        opts.fetch(:permitted_columns) do
          raise 'Specify permitted_columns in routes or the controller'
        end
      end

      Object.const_set(controller_name(path), controller)
    end

    def self.exists?(path)
      error = false

      begin
        controller_name(path).constantize
      rescue NameError
        error = true
      end

      error
    end

    def self.controller_name(path)
      "#{path.camelize}Controller"
    end
  end
end
