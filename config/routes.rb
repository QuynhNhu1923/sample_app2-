Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    resources :microposts, only: %i(index)
    resources :users, only: %i(new show)

    root "static_pages#home"
    get "/help", to: "static_pages#help"
    get "/about", to: "static_pages#about"
    get "/contact", to: "static_pages#contact"
    get "/signup", to: "users#new"
    get "login", to: "sessions#new"
    get "/home", to: "static_pages#home"
    
    post "/signup", to: "users#create"
    post "login", to: "sessions#create"

    delete "logout", to: "sessions#destroy"
  end
end
