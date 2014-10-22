class PermittedColumnsController < ApplicationController
  include Databound

  private

  def model
    User
  end

  def permitted_columns
    %i(name)
  end
end
