require 'spec_helper'

describe PermitController, type: :controller do
  CURRENT_USER_ID = 1

  before :each do
    Project.create(city: 'LA', user_id: 5)
    Project.create(city: 'LA', user_id: 1)
  end

  describe '#read' do
    it 'raise when scope is not permitted' do
      data = {
        data: {
          city: 'LA',
          dont_permit: true,
        },
        scope: {},
      }

      assert_responses(
        -> { post(:where, javascriptize(data)) },
        Databound::NotPermittedError,
        'Request for read not permitted',
      )
    end

    it 'should update when param is permitted' do
      data = {
        data: {
          city: 'Barcelona',
          user_id: 1,
        },
        scope: {},
      }

      expect { post(:where, javascriptize(data)) }.not_to raise_error
    end
  end

  describe '#create' do
    it 'raise when scope is not permitted' do
      data = {
        data: {
          city: 'Barcelona',
          user_id: 2,
        },
        scope: {},
      }

      assert_responses(
        -> { post(:create, javascriptize(data)) },
        Databound::NotPermittedError,
        'Request for create not permitted',
      )
    end

    it 'should update when param is permitted' do
      data = {
        data: {
          city: 'Barcelona',
          user_id: 1,
        },
        scope: {},
      }

      expect { post(:create, javascriptize(data)) }.not_to raise_error
    end
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

      assert_responses(
        -> { post(:update, javascriptize(data)) },
        Databound::NotPermittedError,
        'Request for update not permitted',
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

      assert_responses(
        -> { post(:destroy, javascriptize(data)) },
        Databound::NotPermittedError,
        'Request for destroy not permitted',
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
