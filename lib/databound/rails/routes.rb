class ActionDispatch::Routing::Mapper
  def databound(*resources)
    namespace = @scope[:path]
    namespace = namespace[1..-1] if namespace
    opts = resources.pop if resources.last.is_a?(Hash)
    Databound::Utils.databound_to_application_controller!

    resources.each do |resource|
      Rails.application.routes.draw do
        controller = [namespace, resource].compact.join('/')
        Databound::Utils.create_controller_unless_exists(controller, resource, opts)

        %i(where create update destroy).each do |name|
          path = [namespace, resource, name].compact.join('/')
          to = [controller, name].join('#')
          post path => to
        end
      end
    end
  end
end
