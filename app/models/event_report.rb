class EventReport < ActiveRecord::Base
  self.inheritance_column = 'there_is_no_sti_here'

  def self.pull_requests_chronological
    where(type: 'PullRequestEvent').order(:created_at)
  end
end
