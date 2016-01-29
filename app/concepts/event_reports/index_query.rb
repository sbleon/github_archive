module EventReports
  class IndexQuery
    include ActiveModel::Model

    attr_accessor :event_type, :materialize, :repo_fragment, :username_fragment

    def initialize(params)
      @event_type = params[:event_type]
      @materialize = params[:materialize] == '1'
      @repo_fragment = params[:repo_fragment]
      @username_fragment = params[:username_fragment]
    end

    def self.event_types
      %w(
        PullRequestReviewCommentEvent
        MemberEvent
        PushEvent
        ReleaseEvent
        GollumEvent
        CreateEvent
        DeleteEvent
        PublicEvent
        ForkEvent
        PullRequestEvent
        WatchEvent
        IssuesEvent
        IssueCommentEvent
        CommitCommentEvent
      )
    end

    def result
      query = model.all
      if event_type.present?
        query = query.where(type: event_type)
      end
      if repo_fragment.present?
        query = query.where('repo_name like ?', "#{repo_fragment}%")
      end
      if username_fragment.present?
        query = query.where('username like ?', "#{username_fragment}%")
      end
      query.order(created_at: :desc)
    end

    private

    def model
      materialize ? FastEventReport : EventReport
    end
  end
end
