Rails.application.routes.draw do
  # 메인 페이지
  root "pages#home"

  # 공개 페이지
  get "portfolio", to: "pages#portfolio"
  get "contact", to: "pages#contact"
  post "contact", to: "pages#create_quote"
  get "pricing", to: "pages#pricing"

  # 어드민 페이지
  namespace :admin do
    root "dashboard#index"
    resources :portfolios
    resources :quotes, only: [ :index, :show ]
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
