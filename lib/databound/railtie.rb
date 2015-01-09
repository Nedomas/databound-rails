module Databound
  class Railtie < Rails::Railtie
    initializer 'databound.databound_to_action_controller' do
      ActiveSupport.on_load(:action_controller) do
        extend Databound::Initializer
      end
    end
  end
end
