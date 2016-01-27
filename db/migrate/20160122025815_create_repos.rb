class CreateRepos < ActiveRecord::Migration[5.0]
  def change
    create_table :repos do |t|
      t.string :name, null: false
      t.string :url, null: false

      t.timestamps null: false
    end
  end
end
