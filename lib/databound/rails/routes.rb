class ActionDispatch::Routing::Mapper
  def databound(*resources)
    namespace = @scope[:path]
    namespace = namespace[1..-1] if namespace

    resources.each do |resource|
      Rails.application.routes.draw do
        controller = [namespace, resource].compact.join('/')
        Databound::Utils.create_controller_unless_exists(controller, resource)

        %i(where create update destroy).each do |name|
          path = [namespace, resource, name].compact.join('/')
          to = [controller, name].join('#')
          post path => to
        end
      end
    end
  end
end
