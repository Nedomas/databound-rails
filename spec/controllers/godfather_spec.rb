require 'spec_helper'

describe UsersController, type: :controller do
  describe '#create' do
    before :each do
      data = {
        scope: {},
        data: {
          name: 'John',
        },
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
end
