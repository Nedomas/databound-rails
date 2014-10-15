class UsersController < ApplicationController
  include Godfather

  private

  def model
    User
  end
end
