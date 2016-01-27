class CreateEventReportsView < ActiveRecord::Migration[5.0]
  def up
    sql =<<-SQL.strip_heredoc
      create view event_reports as
      select events.id, events.type, events.created_at, events.payload,
        repos.id as repo_id, repos.name as repo_name, repos.url as repo_url,
        users.id as user_id, users.username, users.url as user_url, users.avatar_url
      from events
        inner join repos on repos.id = events.repo_id
        inner join users on users.id = events.user_id
    SQL

    connection.execute(sql)
  end

  def down
    sql = "drop view event_reports"
    connection.execute(sql)
  end
end
