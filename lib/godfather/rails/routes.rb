class ActionDispatch::Routing::Mapper
  def godfather_of(*resources)
    namespace = @scope[:path]
    namespace = namespace[1..-1] if namespace

    resources.each do |resource|
      Rails.application.routes.draw do
        %i(where create update destroy).each do |name|
          path = [namespace, resource, name].compact.join('/')
          controller = [namespace, resource].compact.join('/')
          to = [controller, name].join('#')
          post path => to
        end
      end
    end
  end
end
