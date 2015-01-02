module Databound
  class NotPermittedError < RuntimeError; end
  class Manager
    def initialize(controller)
      @model = controller.send(:model)
      @permitted_columns = controller.send(:permitted_columns)

      scope_js = controller.params[:scope]
      data_js = controller.params[:data]
      extra_where_scopes_js = controller.params[:extra_where_scopes] || '[]'

      @scope = Databound::Data.new(controller, scope_js)
      @data = Databound::Data.new(controller, data_js).to_h

      @extra_where_scopes = JSON.parse(extra_where_scopes_js).map do |extra_scope|
        Databound::Data.new(controller, extra_scope)
      end
    end

    def find_scoped_records(only_extra_scopes: false)
      records = []
      records << @scope.records(@model)

      @extra_where_scopes.each do |extra_scope|
        records << extra_scope.records(@model)
      end

      if only_extra_scopes
        records.flatten
      else
        records.map { |record| record.where(@data) }.flatten
      end
    end

    def create_from_data
      check_params!
      @model.where(@scope.to_h).create(@data)
    end

    def update_from_data
      id = @data.delete('id')

      check_params!
      record = @model.find(id)
      record.update(@data)

      record
    end

    def destroy_from_data
      @model.find(@data['id']).destroy
    end

    private

    def check_params!
      return if @permitted_columns == :all
      return if unpermitted_columns.empty?

      raise NotPermittedError, "Request includes unpermitted columns: #{unpermitted_columns.join(', ')}"
    end

    def unpermitted_columns
      requested = [@scope, @data].map(&:to_h).flat_map(&:keys)
      requested - @permitted_columns.map(&:to_s)
    end
  end
end
