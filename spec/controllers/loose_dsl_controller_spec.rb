require 'spec_helper'

describe LooseDslController, type: :controller do
  describe '#create strict' do
    before :each do
      data = {
        data: {
          name: 'John',
          city: 'hottest',
        },
        scope: {},
        extra_find_scopes: [],
      }

      post(:create, javascriptize(data))
    end

    it 'responds consistently to js' do
      expect(rubize(response)).to eq(
        success: true,
        id: '1',
        scoped_records: all_records,
      )
    end

    it 'creates the record' do
      user = User.find(1)
      user_attributes = user.attributes.to_options

      expect(user_attributes.slice(:id, :name, :city)).to eq(
        id: 1,
        name: 'John',
        city: 'Miami',
      )
    end
  end

  describe '#create loose' do
    before :each do
      data = {
        data: {
          name: 'John',
          city: 'New York',
        },
        scope: {},
        extra_find_scopes: [],
      }

      post(:create, javascriptize(data))
    end

    it 'responds consistently to js' do
      expect(rubize(response)).to eq(
        success: true,
        id: '1',
        scoped_records: all_records,
      )
    end

    it 'creates the record' do
      user = User.find(1)
      user_attributes = user.attributes.to_options

      expect(user_attributes.slice(:id, :name, :city)).to eq(
        id: 1,
        name: 'John',
        city: 'New York',
      )
    end
  end

  describe '#update strict' do
    before :each do
      User.create(name: 'John', city: 'New York')

      data = {
        data: {
          id: 1,
          city: 'hottest',
        },
        scope: {},
        extra_find_scopes: [],
      }

      post(:update, javascriptize(data))
    end

    it 'responds consistently to js' do
      expect(rubize(response)).to eq(
        success: true,
        id: '1',
        scoped_records: all_records,
      )
    end

    it 'updates the record' do
      user = User.find(1)
      user_attributes = user.attributes.to_options

      expect(user_attributes.slice(:id, :name, :city)).to eq(
        id: 1,
        name: 'John',
        city: 'Miami',
      )
    end
  end

  describe '#update loose' do
    before :each do
      User.create(name: 'John', city: 'New York')

      data = {
        data: {
          id: 1,
          city: 'Los Angeles',
        },
        scope: {},
        extra_find_scopes: [],
      }

      post(:update, javascriptize(data))
    end

    it 'responds consistently to js' do
      expect(rubize(response)).to eq(
        success: true,
        id: '1',
        scoped_records: all_records,
      )
    end

    it 'updates the record' do
      user = User.find(1)
      user_attributes = user.attributes.to_options

      expect(user_attributes.slice(:id, :name, :city)).to eq(
        id: 1,
        name: 'John',
        city: 'Los Angeles',
      )
    end
  end
end
