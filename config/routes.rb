Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :events
  resources :event_members, except: [:new, :show, :edit, :update]
  get '/signup', to: 'users#new'
  resources :users, except: [:new]
  resources :tags, only: [:show]
  root 'pages#home'
end
