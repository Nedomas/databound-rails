class PermittedColumnsController < ApplicationController
  include Godfather

  private

  def model
    User
  end

  def permitted_columns
    %i(name)
  end
end
