module Databound
  class Utils
    def self.create_controller_unless_exists(path, resource)
      return if exists?(path)

      controller = Class.new(ApplicationController)
      controller.send(:include, Databound)
      controller.send(:define_method, :model) do
        resource.to_s.classify.constantize
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
