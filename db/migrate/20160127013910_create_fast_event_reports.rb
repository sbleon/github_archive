class CreateFastEventReports < ActiveRecord::Migration[5.0]
  def change
    create_table :fast_event_reports, id: false do |t|
      t.integer :id, limit: 8, null: false, primary_key: true
      t.string :type, null: false
      t.datetime :created_at, null: false
      t.jsonb :payload, null: false
      t.integer :repo_id, null: false
      t.string :repo_name, null: false
      t.string :repo_url, null: false
      t.integer :user_id, null: false
      t.string :username, null: false
      t.string :user_url, null: false
      t.string :avatar_url, null: false
    end

    add_index :fast_event_reports, :id, unique: true
    add_index :fast_event_reports, :created_at

    reversible do |dir|
      sql = nil
      dir.up do
        cols = %w(
          id type created_at payload
          repo_id repo_name repo_url username
          user_id user_url avatar_url
        ).join(', ')
        sql =<<-SQL.strip_heredoc
          -- # EVENTS # --
          create function fn_trig_upsert_event()
          returns trigger language plpgsql as $$
          begin
            insert into fast_event_reports(#{cols})
            select #{cols}
            from event_reports
            where id = new.id

            on conflict(id) do update
            set type = excluded.type,
                created_at = excluded.created_at,
                payload = excluded.payload;

            return null;
          end
          $$;

          create trigger trig_upsert_event after insert or update on events
          for each row execute procedure fn_trig_upsert_event();

          -- # REPOS # --
          create function fn_trig_upsert_repo()
          returns trigger language plpgsql as $$
          begin
            insert into fast_event_reports(#{cols})
            select #{cols}
            from event_reports
            where repo_id = new.id

            on conflict(id) do update
            set repo_name = excluded.repo_name,
                repo_url = excluded.repo_url;

            return null;
          end
          $$;

          create trigger trig_upsert_repo after insert or update on repos
          for each row execute procedure fn_trig_upsert_repo();

          -- # USERS # --
          create function fn_trig_upsert_user()
          returns trigger language plpgsql as $$
          begin
            insert into fast_event_reports(#{cols})
            select #{cols}
            from event_reports
            where user_id = new.id

            on conflict(id) do update
            set username = excluded.username,
                avatar_url = excluded.avatar_url,
                user_url = excluded.user_url;

            return null;
          end
          $$;

          create trigger trig_upsert_user after insert or update on users
          for each row execute procedure fn_trig_upsert_user();
        SQL
      end
      dir.down do
        sql = <<-SQL.strip_heredoc
          drop trigger trig_upsert_event on events;
          drop function fn_trig_upsert_event();
          drop trigger trig_upsert_repo on repos;
          drop function fn_trig_upsert_repo();
          drop trigger trig_upsert_user on users;
          drop function fn_trig_upsert_user();
        SQL
      end

      connection.execute(sql)
    end
  end
end
