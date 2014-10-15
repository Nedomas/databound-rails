ActiveRecord::Schema.define do
  create_table(:users, force: true) do |t|
    t.string :name
    t.text :city
    t.timestamps
  end
end
