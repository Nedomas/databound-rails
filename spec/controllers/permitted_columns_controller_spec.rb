require 'spec_helper'

describe PermittedColumnsController, type: :controller do
  describe '#create' do
    it 'raise when param is not permitted' do
      data = {
        data: {
          city: 'Barcelona',
        },
        scope: {},
        extra_find_scopes: [],
      }

      expect { post(:create, javascriptize(data)) }.to raise_error(
        Godfather::UnpermittedError,
        'Request includes unpermitted columns: city',
      )
    end

    it 'should create when param is permitted' do
      data = {
        data: {
          name: 'Nikki',
        },
        scope: {},
        extra_find_scopes: [],
      }

      expect { post(:create, javascriptize(data)) }.not_to raise_error
    end
  end

  describe '#update' do
    before :each do
      User.create(name: 'Nikki')
    end

    it 'raise when param is not permitted' do
      data = {
        data: {
          id: 1,
          city: 'Barcelona',
        },
        scope: {},
        extra_find_scopes: [],
      }

      expect { post(:update, javascriptize(data)) }.to raise_error(
        Godfather::UnpermittedError,
        'Request includes unpermitted columns: city',
      )
    end

    it 'should create when param is permitted' do
      data = {
        data: {
          id: 1,
          name: 'Nikki',
        },
        scope: {},
        extra_find_scopes: [],
      }

      expect { post(:update, javascriptize(data)) }.not_to raise_error
    end
  end

  describe 'via scope' do
    describe '#create' do
      it 'should raise when not permitted' do
        data = {
          data: {
            name: 'Nikki',
          },
          scope: { city: 'Barcelona' },
          extra_find_scopes: [],
        }

        expect { post(:create, javascriptize(data)) }.to raise_error(
          Godfather::UnpermittedError,
          'Request includes unpermitted columns: city',
        )
      end
    end

    describe '#update' do
      it 'should raise when not permitted' do
        User.create(name: 'Nikki', city: 'New York')
        data = {
          data: {
            name: 'Nikki',
          },
          scope: { city: 'Barcelona' },
          extra_find_scopes: [],
        }

        expect { post(:update, javascriptize(data)) }.to raise_error(
          Godfather::UnpermittedError,
          'Request includes unpermitted columns: city',
        )
      end
    end
  end
end
