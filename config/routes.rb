Rails.application.routes.draw do
  resources :users
  root 'pages#home'
end
