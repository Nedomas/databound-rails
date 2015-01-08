class LooseDslController < ApplicationController
  databound do
    model :user
    columns :name, :city

    dsl(:city, :hottest, strict: false) { 'Miami' }
  end
end
