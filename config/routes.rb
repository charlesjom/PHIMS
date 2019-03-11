Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, path: 'accounts', controllers: { registrations: 'users/registrations'}

  unauthenticated do
    root to: redirect('/users/sign_in')
  end
 
  authenticated :users do
    root to: 'users#show', as: :authenticated_root
  end

  get 'user/me', to: 'users#show'

  resources :users, only: :show
  resource :medical_history
  resource :personal_data
end
