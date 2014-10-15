require 'spec_helper'

describe UsersController, type: :controller do
  describe 'raise error when model undefined' do
    it 'requires a name' do
      post(:create, { scope: '{}', data: '{}', extra_find_scopes: '[]' })
    end
  end
end
