Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, :path => 'accounts', :controllers => { registrations: 'users/registrations'}

  authenticated :users do
    root to: 'users#show', as: :authenticated_root
  end
  root to: redirect('/users/sign_in')

  resources :users, only: :show
  resource :medical_history
  resource :personal_data
end
