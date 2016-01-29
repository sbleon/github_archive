class EventReportsController < ApplicationController
  def index
    start_time = Time.current

    params.permit!
    params[:page] ||= 1

    @event_types = EventReports::IndexQuery.event_types
    @query = EventReports::IndexQuery.new(params[:event_reports_index_query])
    @count = @query.result.count
    @event_reports = @query.result.page(params[:page]).load
    @time_elapsed = (1000.0 * (Time.current - start_time)).to_i
    render
  end
end
