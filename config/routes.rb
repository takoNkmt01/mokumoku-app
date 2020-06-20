Rails.application.routes.draw do
  root 'events#index'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  post '/test_user', to: 'test_user#create'
  delete '/logout', to: 'sessions#destroy'
  resources :tags, only: [:show]
  resources :events do
    resources :comments, only: [:create, :destroy]
    resources :event_members, except: [:new, :show, :edit, :update]
  end
  resources :users, except: [:new] do
    get 'events/join', to: 'users#join'
    get 'events/host', to: 'users#host'
  end
  get '/signup', to: 'users#new'
end
