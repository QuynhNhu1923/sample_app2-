Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    resources :microposts, only: %i(index)
    resources :users, only: %i(index new show create edit update destroy)
    resources :account_activations, only: [:edit]

    root "static_pages#home"
    get "/help", to: "static_pages#help"
    get "/about", to: "static_pages#about"
    get "/contact", to: "static_pages#contact"
    get "/home", to: "static_pages#home"

    get "/signup", to: "users#new"
    post "/signup", to: "users#create"

    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"
    
  end
end
