require 'spec_helper'

describe SecurityController, type: :controller do
  describe 'raise error' do
    it 'when model is not defined' do
      expect { post(:create) }.to raise_error(RuntimeError)
    end
  end
end
