require 'spec_helper'

describe PermitUpdateDestroyController, type: :controller do
  CURRENT_USER_ID = 1

  before :each do
    Project.create(city: 'LA', user_id: 5)
    Project.create(city: 'LA', user_id: 1)
  end

  describe '#update' do
    it 'raise when scope is not permitted' do
      data = {
        data: {
          id: 1,
          city: 'Barcelona',
        },
        scope: {},
      }

      expect { post(:update, javascriptize(data)) }.to raise_error(
        Databound::NotPermittedError,
        'Request for update or destroy not permitted',
      )
    end

    it 'should update when param is permitted' do
      data = {
        data: {
          id: 2,
          city: 'Barcelona',
        },
        scope: {},
      }

      expect { post(:update, javascriptize(data)) }.not_to raise_error
    end
  end

  describe '#destroy' do
    it 'raise when scope is not permitted' do
      data = {
        data: {
          id: 1,
        },
        scope: {},
      }

      expect { post(:destroy, javascriptize(data)) }.to raise_error(
        Databound::NotPermittedError,
        'Request for update or destroy not permitted',
      )
    end

    it 'should destroy when param is permitted' do
      data = {
        data: {
          id: 2,
        },
        scope: {},
      }

      expect { post(:destroy, javascriptize(data)) }.not_to raise_error
    end
  end
end
