Rails.application.routes.draw do
  # 메인 페이지
  # Design Template Previews
  get 'templates/beauty', to: 'templates#beauty'
  get 'templates/dining', to: 'templates#dining'
  get 'templates/gym', to: 'templates#gym'
  get 'templates/study', to: 'templates#study'
  get 'templates/stay', to: 'templates#stay'
  get 'templates/corporate', to: 'templates#corporate'
  get 'templates/ecommerce', to: 'templates#ecommerce'
  get 'templates/cafe', to: 'templates#cafe'
  get 'templates/portfolio', to: 'templates#portfolio'
  get 'templates/medical', to: 'templates#medical'
  get 'templates/law', to: 'templates#law'
  get 'templates/wedding', to: 'templates#wedding'
  get 'templates/cleaning', to: 'templates#cleaning'
  get 'templates/agency', to: 'templates#agency'
  get 'templates/consulting', to: 'templates#consulting'
  get 'templates/academy', to: 'templates#academy'

  root "pages#home"

  # 공개 페이지
  get "portfolio", to: "pages#portfolio"
  get "contact", to: "pages#contact"
  post "contact", to: "pages#create_quote"
  get "pricing", to: "pages#pricing"

  # 템플릿 페이지
  resources :design_templates, only: [:index]
  get 'templates', to: redirect('/design_templates')

  # 어드민 페이지
  namespace :admin do
    root "dashboard#index"
    resources :sessions, only: [:new, :create, :destroy]
    resources :portfolios
    resources :quotes, only: [ :index, :show ]
    resources :design_templates
  end

  # SEO
  get '/robots.txt', to: 'pages#robots'
  get '/sitemap.xml', to: 'pages#sitemap'

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
