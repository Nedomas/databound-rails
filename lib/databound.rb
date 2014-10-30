require 'databound/extensions'
require 'databound/version'
require 'databound/data'
require 'databound/manager'
require 'databound/rails/routes'

module Databound
  def self.included(base)
    base.send(:before_action, :init_crud, only: %i(where create update destroy))
    base.extend(ClassMethods)
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
      scoped_records: serialized(scoped_records),
    }
  end

  def update
    record = @crud.update_from_data

    render json: {
      success: true,
      id: record.id,
      scoped_records: serialized(scoped_records),
    }
  end

  def destroy
    @crud.destroy_from_data

    render json: {
      success: true,
      scoped_records: serialized(scoped_records),
    }
  end

  private

  def serialized(records)
    return records unless defined?(ActiveModel::Serializer)

    serializer = ActiveModel::Serializer.serializer_for(records.first)
    return records unless serializer

    ActiveModel::ArraySerializer.new(records).to_json
  end

  def model
    raise 'Override model method to specify a model to be used in CRUD'
  end

  def permitted_columns
    # permit all by default
    model.column_names
  end

  def init_crud
    @crud = Databound::Manager.new(self)
  end

  def scoped_records
    @crud.find_scoped_records(only_extra_scopes: true)
  end

  module ClassMethods
    attr_reader :dsls
    attr_reader :stricts

    def dsl(name, value, strict: true, &block)
      @stricts ||= {}
      @stricts[name.to_s] = strict

      @dsls ||= {}
      @dsls[name.to_s] ||= {}
      @dsls[name.to_s][value.to_s] = block
    end
  end
end
