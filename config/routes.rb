Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :events
  get '/signup', to: 'users#new'
  resources :users, except: [:new]
  root 'pages#home'
end
