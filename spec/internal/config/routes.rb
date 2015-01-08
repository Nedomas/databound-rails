Rails.application.routes.draw do
  databound :users
  databound :no_model
  databound :permitted_columns
  databound :dsl
  databound :loose_dsl
  databound :messages, columns: :table_columns
  databound :permit_update_destroy
  databound :posts, columns: %i(title)
end
