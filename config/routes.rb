Rails.application.routes.draw do
  resources :event_reports, only: :index
end
