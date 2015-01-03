class PermitUpdateDestroyController < ApplicationController
  include Databound

  private

  def model
    Project
  end

  permit_update_destroy? do |record|
    record.user_id == CURRENT_USER_ID
  end
end
