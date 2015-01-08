class PermitUpdateDestroyController < ApplicationController
  databound do
    model :project
    columns :name, :city

    permit(:update, :destroy) do |_, record|
      record.user_id == CURRENT_USER_ID
    end
  end
end
