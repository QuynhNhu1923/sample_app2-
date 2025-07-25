Rails.application.routes.draw do
  get 'sessions/new'
  scope "(:locale)", locale: /en|vi/ do
    resources :microposts, only: %i(index)
<<<<<<< HEAD
<<<<<<< HEAD
    resources :users, only: %i(new show)
=======
    resources :users, only: %i(new create show destroy)
>>>>>>> 11aa80d (Completed chapter 8)
=======
    resources :users, only: %i(new show destroy)
>>>>>>> b586c97 (Completed chapter 9)

    root "static_pages#home"
    get "/help", to: "static_pages#help"
    get "/about", to: "static_pages#about"
    get "/contact", to: "static_pages#contact"
    get "/signup", to: "users#new"
    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"
    get "/home", to: "static_pages#home"
    
    post "/signup", to: "users#create"
  end
end
