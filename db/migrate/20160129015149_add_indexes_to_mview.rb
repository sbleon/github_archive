class AddIndexesToMview < ActiveRecord::Migration[5.0]
  def up
    connection.execute('
      create index index_fast_event_reports_on_repo_name_and_type
      on fast_event_reports
      (repo_name varchar_pattern_ops, type varchar_pattern_ops);

      create index index_fast_event_reports_on_username_and_type
      on fast_event_reports
      (username varchar_pattern_ops, type varchar_pattern_ops);
    ')
  end

  def down
    connection.execute('
      drop index index_fast_event_reports_on_repo_name_and_type;
      drop index index_fast_event_reports_on_username_and_type;
    ')
  end
end
