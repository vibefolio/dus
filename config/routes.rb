Rails.application.routes.draw do
  # 메인 페이지
  # Design Template Previews
  get 'templates/beauty', to: 'templates#beauty'
  get 'templates/dining', to: 'templates#dining'
  get 'templates/gym', to: 'templates#gym'
  get 'templates/study', to: 'templates#study'
  get 'templates/stay', to: 'templates#stay'

  root "pages#home"

  # 공개 페이지
  get "portfolio", to: "pages#portfolio"
  get "contact", to: "pages#contact"
  post "contact", to: "pages#create_quote"
  get "pricing", to: "pages#pricing"

  # 템플릿 페이지
  resources :design_templates, only: [:index]

  # 어드민 페이지
  namespace :admin do
    root "dashboard#index"
    resources :portfolios
    resources :quotes, only: [ :index, :show ]
    resources :design_templates
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
