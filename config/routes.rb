Rails.application.routes.draw do
  root 'tournaments#index'

  resources :tournaments, only: [:index, :new, :create, :show, :update] do
    resources :rounds, only: [:create, :show, :edit, :update]
  end

  get '/tournaments/:tournament_id/rounds/:id/list', to: 'rounds#list'
end
