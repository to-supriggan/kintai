Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "menus#index"
  resources :users, only: [:index, :edit, :update]
  resources :worktimes do
    collection do
      get "pre_edit", to: "worktimes#pre_edit"
      post "go_workshow", to: "worktimes#go_workshow"
    end
  end
  resources :reasons, only: [:index, :show, :create, :update]
  resources :monthly do
    collection do
      post "monthshow", to: "monthly#monthshow"
      post "dayshow", to: "monthly#dayshow"
    end
  end
end
