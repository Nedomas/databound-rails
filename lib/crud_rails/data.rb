module CrudRails
  class Data
    CONTEXT_CLASSES = {
      # 'Client' => Client,
      # 'Shop' => Shop,
      # 'User' => User,
    }.freeze

    CONTEXT_METHOD_NAMES = {
      # 'Client' => :client,
      # 'Shop' => :shop,
      # 'User' => :user,
    }.freeze

    def initialize(context, json)
      @context = context

      return unless json
      hash = JSON.parse(json) if json.is_a?(String) rescue binding.pry
      hash = json if json.is_a?(Hash)
      @scope = expand_dsl(hash)
    end

    def records(model)
      model.where(@scope)
    end

    def to_h
      @scope
    end

    private

    def expand_dsl(raw_scope)
      result = raw_scope.dup

      if raw_scope['context_id'] == 'current'
        context_type_string = raw_scope['context_type']

        result['context_type'] = convert_to_context_class(context_type_string)
        result['context_id'] = convert_to_context_id(context_type_string)
      end

      result
    end

    def convert_to_context_class(string)
      CONTEXT_CLASSES[string]
    end

    def convert_to_context_id(string)
      @context.send(convert_to_context_method_name(string)).id
    end

    def convert_to_context_method_name(string)
      CONTEXT_METHOD_NAMES[string]
    end
  end
end
