class EventReportsController < ApplicationController
  def index
    start_time = Time.current

    params.permit!
    params[:page] ||= 1

    @event_types = EventReports::IndexQuery.event_types
    index_params = params[:event_reports_index_query] || {}
    @query = EventReports::IndexQuery.new(index_params)
    @count = @query.result.count
    @event_reports = @query.result.page(params[:page]).load
    @time_elapsed = (1000.0 * (Time.current - start_time)).to_i
    render
  end
end
