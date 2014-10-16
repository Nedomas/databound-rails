class DslController < ApplicationController
  include Godfather

  private

  def model
    User
  end

  dsl(:city, :hottest) do
    'Miami'
  end

  dsl(:city, :coldest) do |params|
    "Where #{params[:name]} lives"
  end
end
