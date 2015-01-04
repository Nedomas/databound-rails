module Databound
  class Utils
    def self.create_controller_unless_exists(path, resource, opts)
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
      begin
        controller_name(path).constantize
      rescue NameError
        return false
      end

      true
    end

    def self.controller_name(path)
      "#{path.camelize}Controller"
    end
  end
end
