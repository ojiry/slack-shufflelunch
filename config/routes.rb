Rails.application.routes.draw do
  namespace :slack do
  end
  namespace :slack do
    resources :commands, only: :create
  end
end
