module Databound
  class Initializer
    def self.add_application_controller_configs!
      def ApplicationController.databound(model = nil, &block)
        include Databound

        send(:define_method, :databound_config) do
          Databound::Config.new(block, model)
        end
      end
    end
  end
end
