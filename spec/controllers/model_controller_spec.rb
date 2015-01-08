require 'spec_helper'

describe ProjectsController do
  describe 'via routes' do
    it 'should be able to specify model via routes' do
      expect(ProjectsController.new.databound_config.read(:model)).to equal(:user)
    end

    it 'should be able to specify columns via routes' do
      expect(ProjectsController.new.databound_config.read(:columns))
        .to eql(%i(city user_id))
    end
  end
end

describe NoModelController, type: :controller do
  describe 'raise error' do
    it 'when model is not defined' do
      expect { post(:create) }.to raise_error(RuntimeError)
    end
  end
end
