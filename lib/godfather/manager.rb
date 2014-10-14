module Godfather
  class Manager
    def initialize(controller, model, scope_js, data_js, extra_find_scopes_js = '[]')
      @model = model
      @scope = Godfather::Data.new(controller, scope_js)
      @data = Godfather::Data.new(controller, data_js).to_h

      @extra_find_scopes = JSON.parse(extra_find_scopes_js).map do |extra_scope|
        Godfather::Data.new(controller, extra_scope)
      end
    end

    def find_scoped_records
      records = []
      records << @scope.records(@model)

      @extra_find_scopes.each do |extra_scope|
        records << extra_scope.records(@model)
      end

      records.map { |record| record.where(@data) }.flatten
    end

    def create_from_data
      @model.where(@scope.to_h).create(@data)
    end

    def update_from_data
      new_data = @data
      id = new_data.delete('id')

      permitted_cols = @model.column_names
      updatable_data = new_data.slice(*permitted_cols)

      record = @model.find(id)
      record.update(updatable_data)

      record
    end

    def destroy_from_data
      @model.find(@data['id']).destroy
    end
  end
end
