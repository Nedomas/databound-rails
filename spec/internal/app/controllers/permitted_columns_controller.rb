class PermittedColumnsController < ApplicationController
  databound do
    model :user
    columns :name
  end
end
