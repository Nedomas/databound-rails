class UsersController < ApplicationController
  include Databound

  private

  def model
    User
  end
end
