class DslController < ApplicationController
  databound do
    model :user
    columns :name, :city

    dsl(:city, :hottest) { 'Miami' }
    dsl(:city, :coldest) do |params|
      "Where #{params.name} lives"
    end
  end
end
