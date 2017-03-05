Rails.application.routes.draw do
  root 'tournaments#index'

  resources :tournaments, only: [:index, :new, :create, :show]
end
