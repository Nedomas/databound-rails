class LooseDslController < ApplicationController
  include Databound

  private

  def model
    User
  end

  dsl(:city, :hottest, strict: false) do
    'Miami'
  end
end
