require 'spec_helper'

describe PostsController, type: :controller do
  describe '#create' do
    it 'raise when param is not permitted' do
      data = {
        data: {
          description: 'Barcelona',
        },
        scope: {},
      }

      assert_responses(
        -> { post(:create, javascriptize(data)) },
        Databound::NotPermittedError,
        'Request includes unpermitted columns: description',
      )
    end

    it 'should create when param is permitted' do
      data = {
        data: {
          title: 'Hello',
        },
        scope: {},
      }

      expect { post(:create, javascriptize(data)) }.not_to raise_error
    end
  end

  describe '#update' do
    before :each do
      Post.create(title: 'Nikki')
    end

    it 'raise when param is not permitted' do
      data = {
        data: {
          id: 1,
          description: 'Barcelona',
        },
        scope: {},
      }

      assert_responses(
        -> { post(:update, javascriptize(data)) },
        Databound::NotPermittedError,
        'Request includes unpermitted columns: description',
      )
    end

    it 'should update when param is permitted' do
      data = {
        data: {
          id: 1,
          title: 'Hello',
        },
        scope: {},
      }

      expect { post(:update, javascriptize(data)) }.not_to raise_error
    end
  end

  describe 'via scope' do
    describe '#create' do
      it 'should raise when not permitted' do
        data = {
          data: {
            title: 'Hello',
          },
          scope: { description: 'Barcelona' },
        }

        assert_responses(
          -> { post(:create, javascriptize(data)) },
          Databound::NotPermittedError,
          'Request includes unpermitted columns: description',
        )
      end
    end

    describe '#update' do
      it 'should raise when not permitted' do
        Post.create(title: 'Hello', description: 'Barcelona')
        data = {
          data: {
            title: 'Hello 2',
          },
          scope: { description: 'Barcelona 2' },
        }

        assert_responses(
          -> { post(:update, javascriptize(data)) },
          Databound::NotPermittedError,
          'Request includes unpermitted columns: description',
        )
      end
    end
  end
end
