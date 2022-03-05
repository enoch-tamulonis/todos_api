Rails.application.routes.draw do
  resources :users, only: [:create] do
    scope module: :users do
      resources :tasks
    end
  end

  namespace :users do
    resource :auth, only: [:create], controller: "auth"
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
