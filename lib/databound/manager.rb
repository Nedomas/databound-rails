module Databound
  class NotPermittedError < RuntimeError; end
  class Manager
    def initialize(controller)
      @controller = controller
      @model = @controller.send(:model)

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
      check_permit_update_destroy!(record)
      record.update(@data)

      record
    end

    def destroy_from_data
      record = @model.find(@data['id'])
      check_permit_update_destroy!(record)
      record.destroy
    end

    private

    def check_params!
      return if permitted_columns == :all
      return if unpermitted_columns.empty?

      raise NotPermittedError, "Request includes unpermitted columns: #{unpermitted_columns.join(', ')}"
    end

    def check_permit_update_destroy!(record)
      return unless permit_update_destroy_block
      return if permit_update_destroy_block.call(record)

      raise NotPermittedError, 'Request for update or destroy not permitted'
    end

    def permit_update_destroy_block
      @controller.class.permit_update_destroy
    end

    def unpermitted_columns
      requested = [@scope, @data].map(&:to_h).flat_map(&:keys)
      requested - permitted_columns.map(&:to_s)
    end

    def permitted_columns
      @controller.send(:permitted_columns)
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
