require 'databound/extensions'
require 'databound/version'
require 'databound/data'
require 'databound/manager'
require 'databound/utils'
require 'databound/rails/routes'

module Databound
  def self.included(base)
    base.send(:before_action, :init_crud, only: %i(where create update destroy))
    base.extend(ClassMethods)
  end

  def where
    records = @crud.find_scoped_records
    render json: serialize_array(records)
  end

  def create
    record = @crud.create_from_data

    render json: {
      success: true,
      id: serialize(record, :id),
      scoped_records: serialize_array(scoped_records),
    }
  end

  def update
    record = @crud.update_from_data

    render json: {
      success: true,
      id: serialize(record, :id),
      scoped_records: serialize_array(scoped_records),
    }
  end

  def destroy
    @crud.destroy_from_data

    render json: {
      success: true,
      scoped_records: serialize_array(scoped_records),
    }
  end

  private

  def serialize_array(records)
    return records.to_json unless defined?(ActiveModel::Serializer)

    serializer = ActiveModel::Serializer.serializer_for(records.first)
    return records unless serializer

    ActiveModel::ArraySerializer.new(records).to_json
  end

  def serialize(record, attribute)
    unserialized = record.send(attribute)
    return unserialized.to_json unless defined?(ActiveModel::Serializer)

    serializer = ActiveModel::Serializer.serializer_for(record)
    return unserialized unless serializer

    serializer.new(record).attributes[:id]
  end

  def model
    raise 'Override model method to specify a model to be used in CRUD'
  end

  def permitted_columns
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
