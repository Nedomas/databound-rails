class PermitController < ApplicationController
  databound do
    model :project
    columns :name, :city, :user_id, :dont_permit

    permit(:read) do |params, records|
      !params.dont_permit
    end

    permit(:create) do |params|
      params.user_id == CURRENT_USER_ID
    end

    permit(:update, :destroy) do |_, record|
      record.user_id == CURRENT_USER_ID
    end
  end
end
