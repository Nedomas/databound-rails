require 'godfather/version'
require 'godfather/data'
require 'godfather/manager'

module Godfather
  module Controller
    def self.included(base)
      base.send(:before_action, :init_crud, only: %i(where create update destroy))
    end

    def where
      records = @crud.find_scoped_records

      render json: serialized(records)
    end

    def create
      record = @crud.create_from_data

      render json: {
        success: true,
        id: record.id,
      }
    end

    def update
      record = @crud.update_from_data

      render json: {
        success: true,
        id: record.id,
      }
    end

    def destroy
      @crud.destroy_from_data

      render json: {
        success: true,
      }
    end

    private

    def serialized(records)
      serializer = ActiveModel::Serializer.serializer_for(records.first)
      return records unless serializer

      ActiveModel::ArraySerializer.new(records).to_json
    end

    def model
      raise 'Override model method to specify a model to be used in CRUD'
    end

    def init_crud
      @crud = Godfather::Manager.new({}, model, params[:scope],
        params[:data], params[:extra_find_scopes])
    end
  end
end
