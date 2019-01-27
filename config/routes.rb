Rails.application.routes.draw do
  root 'tournaments#index'

  resources :tournaments, only: [:index, :new, :create, :show, :update] do
    resources :rounds, only: [:create, :show, :edit, :update] do
      resources :tables, only: [:show, :edit, :update]
    end
  end

  put '/tournaments/:tournament_id/players/:id/dropout', to: 'players#dropout', as: 'dropout_player'
  get '/tournaments/:tournament_id/rounds/:id/list', to: 'rounds#list', as: 'round_list'
end
