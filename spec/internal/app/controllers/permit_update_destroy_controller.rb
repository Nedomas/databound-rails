class PermitUpdateDestroyController < ApplicationController
  include Databound

  private

  def permitted_columns
    %i(name city)
  end

  def model
    Project
  end

  permit_update_destroy? do |record|
    record.user_id == CURRENT_USER_ID
  end
end
