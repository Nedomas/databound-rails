module Databound
  module Initializer
    def databound(model = nil, &block)
      include Databound

      send(:before_filter, :init_crud, only: %i(where create update destroy))
      send(:define_method, :databound_config) do
        Databound::Config.new(block, model)
      end

      rescue_from Databound::NotPermittedError do |exception|
        render(
          status: 405,
          json: {
            message: exception.to_s,
          },
        )
      end
    end
  end
end
