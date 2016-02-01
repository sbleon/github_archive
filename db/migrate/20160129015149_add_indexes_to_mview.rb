class AddIndexesToMview < ActiveRecord::Migration[5.0]
  def up
    # Make indexes on other table match mview
    add_index :events, :type
    remove_index :users, :username

    connection.execute('
      create index index_fast_event_reports_on_repo_name_and_type
      on fast_event_reports
      (repo_name varchar_pattern_ops, type varchar_pattern_ops);

      create index index_fast_event_reports_on_username_and_type
      on fast_event_reports
      (username varchar_pattern_ops, type varchar_pattern_ops);

      create index index_repos_on_name
      on repos (name varchar_pattern_ops);

      create index index_users_on_username
      on users (username varchar_pattern_ops);
    ')
  end

  def down
    connection.execute('
      drop index index_fast_event_reports_on_repo_name_and_type;
      drop index index_fast_event_reports_on_username_and_type;
      drop index index_repos_on_name;
      drop index index_users_on_username;
    ')

    remove_index :events, :type
    add_index :users, :username
  end
end
