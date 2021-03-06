desc 'Import event data'
task import_data: :environment do
  STDOUT.sync = true

  files = Dir.glob(File.join(Rails.root, 'db', 'data', '*.json'))
  files.each do |file|
    processed = 0
    File.open(file).each_line do |line|
      event_hash = JSON.parse(line)
      user_hash = event_hash['actor']
      repo_hash = event_hash['repo']

      begin
        user = User.find_or_create_by(id: user_hash['id']) do |u|
          u.update!(
            username: user_hash['login'],
            url: user_hash['url'],
            avatar_url: user_hash['avatar_url'],
            created_at: event_hash['created_at'],
          )
        end
      rescue
      end

      begin
        repo = Repo.find_or_create_by(id: repo_hash['id']) do |r|
          r.update!(
            name: repo_hash['name'],
            url: repo_hash['url'],
            created_at: event_hash['created_at'],
          )
        end
      rescue
      end

      begin
        Event.find_or_create_by(id: event_hash['id']) do |e|
          e.update!(
            type: event_hash['type'],
            user_id: user_hash['id'],
            repo_id: repo_hash['id'],
            payload: event_hash['payload'],
            created_at: event_hash['created_at'],
          )
        end
      rescue
      end

      processed += 1
      print '.' if (processed % 1000).zero?
    end
  end
end
