Rails.application.routes.draw do
  resources :questions, only: [:new, :create, :show] do
    resources :answers, shallow: true
  end
end
