Mastermind::Application.routes.draw do
  resources :jobs do
    member do
      get 'launch'
      # get 'run'
      # get 'error'
      # get 'complete'
      get 'cancel'
    end
  end
  
  resources :definitions, only: [ :index, :show ]
  resources :providers, only: [ :index, :show ]
  
  root to: 'jobs#index'

  match '/_ruote' => RuoteKit::Application
  match '/_ruote/*path' => RuoteKit::Application
end
