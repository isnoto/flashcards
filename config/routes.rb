Rails.application.routes.draw do
  root 'reviews#show'

  resources :reviews,       only: [:show, :create]
  resources :cards
  resources :registrations, only: [:new, :create]
  resources :profile,       only: [:edit, :update]
  resources :sessions,      only: [:new, :create, :destroy]

  get '/sign_up', to: 'registrations#new', as: 'sign_up'
  get '/log_in', to: 'sessions#new', as: :log_in
  delete '/log_out', to: 'sessions#destroy', as: :log_out

  post 'oauth/callback', to: 'oauths#callback'
  get 'oauth/callback', to: 'oauths#callback'
  get 'oauth/:provider', to: 'oauths#oauth', as: :auth_at_provider
end
