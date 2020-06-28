Rails.application.routes.draw do
  root 'events#index'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  post '/test_user', to: 'test_user#create'
  delete '/logout', to: 'sessions#destroy'

  resources :tags, only: [:show]

  resources :events do
    resources :comments, only: [:create, :destroy]
    resources :event_members, except: [:new, :show, :edit, :update]
    post '/bookmarks', to: 'bookmarks#create'
    delete '/bookmarks', to: 'bookmarks#destroy'
  end

  resources :rooms, only: [:create]
  
  resources :users, except: [:new] do
    get 'events/join', to: 'users#join'
    get 'events/host', to: 'users#host'
    get '/bookmarks', to: 'users#bookmark'
    get '/rooms', to: 'users#rooms'
    resources :notifications, only: [:index]
    resources :messages, only: [:create]
    resources :rooms, only: [:show] do
      delete '/messages/:id', to: 'messages#destroy'
    end
  end
end
