Rails.application.routes.draw do
  root "static_pages#home"

  namespace :admin do
    root "pages#home"
    resources :subpitch_types
    resources :pitches do
      resources :subpitches do
        resources :ratings, only: %i(index destroy), controller: "subpitches/ratings"
      end
    end
    resources :users
    resources :bookings
  end

  post "/login", to: "sessions#create"
  get "/signup", to: "users#new"
  get "/login", to: "sessions#new"
  get "/logout", to: "sessions#destroy"
  match "/auth/:provider/callback", to: "sessions#create", via: [:get, :post]
  match "/auth/failure", to: "sessions#failure", via: [:get, :post]

  get "/blog", to: "static_pages#blog"
  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"
  resources :password_resets, except: :index
  resources :account_activations, only: :edit
  resources :pitches, only: :index do
    resources :subpitches, only: %i(index show) do
      resources :likes, only: %i(create destroy), controller: "subpitches/likes"
    end
  end
  resources :subpitches do
    resources :bookings, only: :new
  end
  resources :bookings do
    resources :pays, only: :new
    resources :ratings, except: :show, controller: "bookings/ratings"
  end
  resources :ratings, only: :index
  patch "pays/update"
  patch "bookings/update", to: "bookings#update"
  post "bookings/create"
  resources :users
end
