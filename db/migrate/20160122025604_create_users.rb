class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :url, null: false, limit: 1000
      t.string :avatar_url, null: false

      t.timestamps null: false
    end

    add_index :users, :username, unique: true
    add_index :users, :url, unique: true
  end
end
