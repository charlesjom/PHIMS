Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  devise_for :users, path: 'accounts', controllers: { registrations: 'users/registrations'}

  devise_scope :user do
    authenticated :user do
      root 'user_records#index'
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  resources :medical_histories, except: [:show, :destroy] do
    collection do
      get :add_attribute
    end
  end
  resources :personal_data, except: [:show, :destroy] do
    collection do
      get :add_attribute
    end
  end

  resources :users, only: [:show]
  resources :user_records, only: [:index, :show, :edit, :update, :destroy] do
    member do
      post :view
      post :share
      get :share_form
      post :edit_data
    end
    resources :share_keys
  end

end
