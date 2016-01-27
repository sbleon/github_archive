class IndexEventsOnCreatedAt < ActiveRecord::Migration[5.0]
  def change
    add_index :events, :created_at
  end
end
