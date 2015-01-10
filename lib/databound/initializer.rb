module Databound
  module Initializer
    def databound(model = nil, &block)
      include Databound

      send(:before_filter, :init_crud, only: %i(where create update destroy))
      send(:define_method, :databound_config) do
        Databound::Config.new(block, model)
      end

      if Rails.application.config.consider_all_requests_local
        rescue_from Databound::NotPermittedError do |exception|
          render(
            status: Databound::NotPermittedError::STATUS,
            json: {
              message: exception.to_s,
            },
          )
        end
      end
    end
  end
end
