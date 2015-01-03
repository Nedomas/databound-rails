Rails.application.routes.draw do
  databound :users
  databound :no_model
  databound :permitted_columns
  databound :dsl
  databound :loose_dsl
  databound :messages
  databound :permit_update_destroy
end
