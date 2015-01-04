ActiveRecord::Schema.define do
  create_table(:users, force: true) do |t|
    t.string :name
    t.string :city
    t.timestamps
  end

  create_table(:messages, force: true) do |t|
    t.string :name
    t.string :city
    t.timestamps
  end

  create_table(:projects, force: true) do |t|
    t.string :city
    t.integer :user_id
    t.timestamps
  end

  create_table(:posts, force: true) do |t|
    t.string :title
    t.string :description
    t.timestamps
  end
end
