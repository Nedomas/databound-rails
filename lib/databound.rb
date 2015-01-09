require 'databound/initializer'
require 'databound/railtie'
require 'databound/extensions'
require 'databound/version'
require 'databound/data'
require 'databound/manager'
require 'databound/config'
require 'databound/controller'
require 'databound/rails/routes'

module Databound
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

  def init_crud
    @crud = Databound::Manager.new(self)
  end

  def scoped_records
    records = @crud.find_scoped_records(only_extra_scopes: true)
    @crud.action_allowed?(:read, records) ? records : []
  end
end
