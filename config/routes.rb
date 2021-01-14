Rails.application.routes.draw do
  root 'questions#index'
  
  devise_for :users

  resources :questions do
    resources :answers, shallow: true

    post :set_best_answer, on: :member
  end
end
