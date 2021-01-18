Rails.application.routes.draw do
  root 'questions#index'
  
  devise_for :users

  resources :questions do
    resources :answers, shallow: true do
      post :delete_file, on: :member
    end

    post :set_best_answer, on: :member
    post :delete_file, on: :member
  end

  resources :links, only: :destroy
end
