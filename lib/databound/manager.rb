module Databound
  class NotPermittedError < RuntimeError; end
  class Manager
    def initialize(controller)
      @controller = controller

      @scope = Databound::Data.new(@controller, scope_js, model)
      @data = Databound::Data.new(@controller, data_js, model).to_h

      @extra_where_scopes = JSON.parse(extra_where_scopes_js).map do |extra_scope|
        Databound::Data.new(@controller, extra_scope, model)
      end
    end

    def find_scoped_records(only_extra_scopes: false)
      check_params!(:read) unless only_extra_scopes

      nodes = [@scope, *@extra_where_scopes].map do |scope|
        model.where(scope.to_h).where_values.reduce(:and)
      end

      query = nodes[1..-1].reduce(nodes.first) do |memo, node|
        node.or(memo)
      end

      records = model.where(query)
      records = filter_by_params!(records) unless only_extra_scopes

      check_permit!(:read, params, records)
      records
    end

    def create_from_data
      check_params!(:create)
      record = model.new(params.to_h)
      check_permit!(:create, params, record)

      record.save
      record
    end

    def update_from_data
      attributes = params.to_h
      id = attributes.delete(:id)

      check_params!(:update)
      record = model.find(id)
      check_permit!(:update, params, record)

      record.update(attributes)
      record
    end

    def destroy_from_data
      record = model.find(params.id)
      check_permit!(:destroy, params, record)
      record.destroy
    end

    private

    def check_params!(action)
      @action = action
      return if columns == :all
      return if unpermitted_columns.empty?

      raise NotPermittedError, "Request includes unpermitted columns: #{unpermitted_columns.join(', ')}"
    end

    def check_permit!(method, params, record = nil)
      permit_checks = @controller.databound_config.read(:permit)
      check = permit_checks[method]

      return unless check
      return if @controller.instance_exec(params, record, &check)

      raise NotPermittedError, "Request for #{method} not permitted"
    end

    def permit_update_destroy_block
      @controller.class.permit_update_destroy
    end

    def unpermitted_columns
      params.to_h.keys - columns - allowed_action_columns
    end

    def params
      OpenStruct.new(@scope.to_h.merge(@data))
    end

    def allowed_action_columns
      @action == :update ? [:id] : []
    end

    def columns
      result = @controller.databound_config.read(:columns)

      case result
      when [:all]
        :all
      when [:table_columns]
        table_columns
      else
        Array(result)
      end
    end

    def table_columns
      if mongoid?
        model.fields.keys.map(&:to_sym)
      elsif activerecord?
        model.column_names.map(&:to_sym)
      else
        raise 'ORM not supported. Use ActiveRecord or Mongoid'
      end
    end

    def mongoid?
      defined?(Moigoid) and model.ancestors.include?(Mongoid::Document)
    end

    def activerecord?
      defined?(ActiveRecord) and model.ancestors.include?(ActiveRecord::Base)
    end

    def model
      raise 'No model specified' unless model_name

      model_name.to_s.camelize.constantize
    end

    def model_name
      @controller.databound_config.read(:model)
    end

    def scope_js
      @controller.params[:scope]
    end

    def data_js
      @controller.params[:data]
    end

    def extra_where_scopes_js
      @controller.params[:extra_where_scopes] || '[]'
    end

    def extra_scope_records
      @extra_where_scopes.flat_map(&:records)
    end

    def filter_by_params!(records)
      records.where(params.to_h)
    end
  end
end
