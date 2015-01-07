module Databound
  class NotPermittedError < RuntimeError; end
  class Manager
    def initialize(controller)
      @controller = controller

      @scope = Databound::Data.new(@controller, scope_js)
      @data = Databound::Data.new(@controller, data_js).to_h

      @extra_where_scopes = JSON.parse(extra_where_scopes_js).map do |extra_scope|
        Databound::Data.new(@controller, extra_scope)
      end
    end

    def find_scoped_records(only_extra_scopes: false)
      records = []
      records << @scope.records(model)

      @extra_where_scopes.each do |extra_scope|
        records << extra_scope.records(model)
      end

      result = if only_extra_scopes
        records.flatten
      else
        records.map { |record| record.where(@data) }.flatten
      end

      check_permit!(:read, params, result)
      result
    end

    def create_from_data
      check_params!
      record = model.where(@scope.to_h).new(@data)
      check_permit!(:create, params, record)

      record.save
      record
    end

    def update_from_data
      id = @data.delete('id')

      check_params!
      record = model.find(id)
      check_permit!(:update, params, record)

      record.update(@data)
      record
    end

    def destroy_from_data
      record = model.find(@data['id'])
      check_permit!(:destroy, params, record)
      record.destroy
    end

    private

    def check_params!
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
      params.to_h.keys - columns
    end

    def params
      OpenStruct.new(@scope.to_h.merge(@data))
    end

    def columns
      result = @controller.databound_config.read(:columns)

      case result
      when :all
        :all
      when :table_columns
        table_columns
      else
        Array(result)
      end
    end

    def table_columns
      # permit all by default
      if mongoid?
        model.fields.keys.map(&:to_sym)
      elsif activerecord?
        model.column_names
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
      @controller.databound_config.read(:model).to_s.camelize.constantize
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
  end
end
