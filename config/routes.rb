Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, :path => 'accounts', :controllers => { registrations: 'users/registrations'}

  authenticated :user do
    root to: 'records#index', as: :authenticated_root
    # TODO fix home index
  end
  root to: redirect('/users/sign_in')

  resources :records
end
