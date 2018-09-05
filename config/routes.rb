Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, :controllers => { registrations: 'users/registrations'}
  root to: 'users#index'

  authenticated :user do
    root to: 'home#index', as: :authenticated_root
  end
  root to: redirect('/users/sign_in')

  # get '/signup', to: 'users#new'
  # post '/signup', to: 'users#create'
end
