Rails.application.routes.draw do
  root 'tournaments#index'

  resources :tournaments, only: [:index, :new, :create, :show] do
    resources :rounds, only: [:create, :show, :edit, :update]
  end
end
