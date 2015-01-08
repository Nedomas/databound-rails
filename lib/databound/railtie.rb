module Databound
  class Railtie < Rails::Railtie
    initializer 'databound.action_controller' do
      ActiveSupport.on_load(:action_controller) do
        Databound::Initializer.add_application_controller_configs!
      end
    end
  end
end
