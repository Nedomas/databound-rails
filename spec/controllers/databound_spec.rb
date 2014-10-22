require 'spec_helper'

describe UsersController, type: :controller do
  describe '#create' do
    before :each do
      data = {
        data: {
          name: 'John',
        },
        scope: {},
        extra_find_scopes: [],
      }

      post(:create, javascriptize(data))
    end

    it 'responds consistently to js' do
      expect(rubize(response)).to eq(success: true, id: 1)
    end

    it 'creates the record' do
      user = User.find(1)
      user_attributes = user.attributes.to_options
      expect(user_attributes.slice(:id, :name)).to eq(id: 1, name: 'John')
    end
  end

  describe '#where' do
    before :each do
      User.create(name: 'John', city: 'New York')
      User.create(name: 'Peter', city: 'New York')
      User.create(name: 'Nikki', city: 'Hollywood')
    end

    it 'respond with empty records' do
      data = {
        data: {
          city: 'Los Angeles',
        },
        scope: {},
        extra_find_scopes: [],
      }

      post(:where, javascriptize(data))
      expect(rubize(response)).to eq([])
    end

    it 'respond with correct records' do
      data = {
        data: {
          city: 'New York',
        },
        scope: {},
        extra_find_scopes: [],
      }

      post(:where, javascriptize(data))
      expect(gather(:name, response)).to eq(%w(John Peter))
    end
  end

  describe '#update' do
    before :each do
      @user = User.create(name: 'John', city: 'New York')
    end

    describe 'update record correctly' do
      before :each do
        data = {
          data: {
            id: @user.id,
            city: 'Moved to Los Angeles',
          },
          scope: {},
          extra_find_scopes: [],
        }

        post(:update, javascriptize(data))
      end

      it 'respond with updated record id' do
        expect(rubize(response)).to eq(success: true, id: @user.id)
      end

      it 'do the update' do
        expect(@user.reload.city).to eq('Moved to Los Angeles')
      end
    end

    it 'respond with error when id is missing' do
      data = {
        data: {
          city: 'Moved to Los Angeles',
        },
        scope: {},
        extra_find_scopes: [],
      }

      expect { post(:update, javascriptize(data)) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#destroy' do
    before :each do
      @user = User.create(name: 'John', city: 'New York')
    end

    describe 'destroy record correctly' do
      before :each do
        data = {
          data: {
            id: @user.id,
          },
          scope: {},
          extra_find_scopes: [],
        }

        post(:destroy, javascriptize(data))
      end

      it 'respond with success' do
        expect(rubize(response)).to eq(success: true)
      end
    end

    it 'respond with error when id is missing' do
      data = {
        data: {
          id: 2,
        },
        scope: {},
        extra_find_scopes: [],
      }

      expect { post(:update, javascriptize(data)) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
