Rails.application.routes.draw do
  resources :boards, only: %i[index show]
  resources :cards, only: %i[create update destroy]

  get "up" => "rails/health#show", as: :rails_health_check

  root "boards#index"
end
