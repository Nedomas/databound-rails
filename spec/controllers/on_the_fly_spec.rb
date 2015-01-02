require 'spec_helper'

describe MessagesController, type: :controller do
  describe '#create' do
    before :each do
      data = {
        data: {
          name: 'John',
          city: 'Prague',
        },
        scope: {},
      }

      post(:create, javascriptize(data))
    end

    it 'responds consistently to js' do
      expect(rubize(response)).to eq(
        success: true,
        id: '1',
        scoped_records: all_records(Message),
      )
    end

    it 'creates the record' do
      message = Message.find(1)
      message_attributes = message.attributes.to_options
      expect(message_attributes.slice(:id, :name)).to eq(id: 1, name: 'John')
    end
  end
end
