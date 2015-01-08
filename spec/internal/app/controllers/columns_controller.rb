class ColumnsController < ApplicationController
  databound do
    model :user
    columns :name
  end
end
