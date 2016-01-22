class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :type, null: false
      t.references :user, null: false
      t.references :repo, null: false
      t.jsonb :payload, null: false
      t.datetime :timestamp, null: false

      t.timestamps null: false
    end

    add_foreign_key :events, :users
    add_foreign_key :events, :repos
  end
end
