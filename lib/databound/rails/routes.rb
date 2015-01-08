class ActionDispatch::Routing::Mapper
  def databound(*resources)
    namespace = @scope[:path]
    namespace = namespace[1..-1] if namespace
    opts = resources.pop if resources.last.is_a?(Hash)
    Databound::Controller.add_application_controller_configs!

    resources.each do |resource|
      Rails.application.routes.draw do
        controller_name = [namespace, resource].compact.join('/')
        Databound::Controller.find_or_create(controller_name, resource, opts)

        %i(where create update destroy).each do |name|
          path = [namespace, resource, name].compact.join('/')
          to = [controller_name, name].join('#')
          post path => to
        end
      end
    end
  end
end
