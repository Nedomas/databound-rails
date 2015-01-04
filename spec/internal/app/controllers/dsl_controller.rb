class DslController < ApplicationController
  include Databound

  private

  def model
    User
  end

  def permitted_columns
    %i(name city)
  end

  dsl(:city, :hottest) do
    'Miami'
  end

  dsl(:city, :coldest) do |params|
    "Where #{params[:name]} lives"
  end
end
