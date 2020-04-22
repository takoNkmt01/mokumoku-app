Rails.application.routes.draw do
  resources :events
  resources :users
  root 'pages#home'
end
