Rails.application.routes.draw do
  get 'user_dashboard/index'
  get 'event_registrations/new'
  get 'event_registrations/create'
  resources :line_items
  resources :carts
  get 'gallery/index'
  get 'gallery/checkout'
  post 'gallery/checkout'
  get 'gallery/search'
  resources :registrations, except: [:new, :create]  # Regular CRUD routes
  get "/dashboard", to: "dashboard#index", as: "dashboard"
  get "/dashboard/index"
  resources :events
  get 'home/index', to: "home#index"
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
  
  resources :event_registrations, only: [:new, :create]

  
  Rails.application.routes.draw do
  get 'user_dashboard/index'
    resources :event_registrations, only: [:new, :create]
    resource :cart, only: [:show, :destroy]
    get "/checkout", to: "checkout#show"
  end
  # post "gallery/checkout", to: "payments#create", as: :create_payment
  get "gallery/purchase_complete"
  get "gallery/purchase_complete_final"
  get "gallery/final_checkout"
  get 'user_dashboard', to: 'user_dashboard#index'


  Rails.application.routes.draw do
  get 'user_dashboard/index'
    resources :gallery do
      collection do
        get 'final_checkout'   # Route to display final payment page
        post 'final_checkout'  # Route to process final payment
      end
    end
  end
  
  get 'data/registered_users', to: 'data#registered_users'


  
  
end
