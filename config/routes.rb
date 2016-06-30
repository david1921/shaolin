MerchantPortal::Application.routes.draw do

  namespace :system do
    resources :users
  end
  resources :system, :only => :index


  resources :info_requests do
    member do
      get 'confirmation'
    end
  end

  resources :registrations do
    member do
      get 'confirmation'
    end
  end

  match "sales" => "sales#index"

  namespace :sales do
    resources :merchants do
      collection do
        get 'search'
      end
      member do
        get :terms_and_conditions
        post :accept_terms_and_conditions
        post :reject_terms_and_conditions
      end
      resources :key_information_agreements, controller: "merchant_key_information_agreements"
      resources :offers, module: :merchants
    end
    resources :offers do
      resources :key_information_agreements, controller: "offer_key_information_agreements"
    end
  end

  resource :session, controller: 'sessions'

  resources :offers do
    member do
      put 'save_progress'
    end
  end

  resources :dashboard, only: [:index]

  resource :image_gallery

  namespace :admin do
    resources :key_information_agreements do
      get 'signature', on: :member
    end
    resources :merchants do
      resources :versions, only: [:index]
      scope module: 'merchants' do
        resources :offers
        resources :merchant_owners
        resources :stores
      end
    end
    resources :offers do
      resources :key_information_agreements, controller: "offer_key_information_agreements"
    end
    resources :library_images do
      collection do
        post :sort
      end
    end
    resources :merchant_validations, only: [:index,:edit,:update]
  end

  resources :post_zones do
    collection do
      get :demo
    end
  end

  root :to => 'home#show'
  match 'home' => 'home#show'

  match 'logout' => 'sessions#destroy', :as => 'logout', :via => :delete

  match 'terms' => 'static_pages#terms'
  match 'privacy' => 'static_pages#privacy'
  match 'support' => 'static_pages#support'
end
