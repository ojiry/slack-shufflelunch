Rails.application.routes.draw do
  namespace :slack do
    resources :interactive_components, only: :create
    resources :slash_commands, only: :create
  end
  get 'auth/slack/callback' => 'slack#callback'
end
