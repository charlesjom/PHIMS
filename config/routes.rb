Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, :controllers => { registrations: 'users/registrations'}
  root to: 'users#index'

  # get '/signup', to: 'users#new'
  # post '/signup', to: 'users#create'
end
