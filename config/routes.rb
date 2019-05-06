Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  devise_for :users, path: 'accounts', controllers: { registrations: 'users/registrations'}

  devise_scope :user do
    authenticated :user do
      root 'users#show', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  get 'user/me', to: 'users#show'
  resources :medical_histories, except: [:show, :destroy]
  resources :personal_data, except: [:show, :destroy]
  resources :users, only: [:show]
  resources :user_records, only: [:index, :show, :edit, :update, :destroy] do
    member do
      post :view
    end
  end

end
