class DslController < ApplicationController
  include Godfather

  private

  def model
    User
  end

  dsl(:city, :hottest) do
    'Miami'
  end
end
