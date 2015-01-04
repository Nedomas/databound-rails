class LooseDslController < ApplicationController
  include Databound

  private

  def permitted_columns
    %i(name city)
  end

  def model
    User
  end

  dsl(:city, :hottest, strict: false) do
    'Miami'
  end
end
