class AddIndexesToFks < ActiveRecord::Migration[5.0]
  def change
    add_index :events, :user_id
    add_index :events, :repo_id
  end
end
