class LooseDslController < ApplicationController
  include Godfather

  private

  def model
    User
  end

  dsl(:city, :hottest, strict: false) do
    'Miami'
  end
end
