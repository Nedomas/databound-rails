class UsersController < ApplicationController
  databound do
    model :user
    columns :name, :city
  end
end
