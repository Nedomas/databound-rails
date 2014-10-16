ActiveRecord::Schema.define do
  create_table(:users, force: true) do |t|
    t.string :name
    t.string :city
    t.timestamps
  end
end
