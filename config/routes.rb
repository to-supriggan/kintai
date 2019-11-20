Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "menus#index"
  resources :users, only: [:index, :edit, :update]
  resources :worktimes, only: [:show, :create, :update]
end