Rails.application.routes.draw do
  namespace :slack do
    resources :event_subscriptions, only: :create
    resources :interactive_components, only: :create
    resources :slash_commands, only: :create
  end
end
