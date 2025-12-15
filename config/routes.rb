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
  get 'templates/sculpt', to: 'templates#sculpt'
  get 'templates/yoga', to: 'templates#yoga'
  get 'templates/nail', to: 'templates#nail'
  get 'templates/barber', to: 'templates#barber'
  get 'templates/flower', to: 'templates#flower'
  get 'templates/burger', to: 'templates#burger'
  get 'templates/wine', to: 'templates#wine'
  get 'templates/salad', to: 'templates#salad'
  get 'templates/dessert', to: 'templates#dessert'
  get 'templates/donut', to: 'templates#donut'
  get 'templates/kinder', to: 'templates#kinder'
  get 'templates/startup', to: 'templates#startup'
  get 'templates/rental', to: 'templates#rental'
  get 'templates/finance', to: 'templates#finance'
  get 'templates/dental', to: 'templates#dental'
  get 'templates/vet', to: 'templates#vet'
  get 'templates/tax', to: 'templates#tax'
  get 'templates/camping', to: 'templates#camping'
  get 'templates/studio', to: 'templates#studio'
  get 'templates/petshop', to: 'templates#petshop'
  get 'templates/hotel', to: 'templates#hotel'
  get 'templates/pension', to: 'templates#pension'
  get 'templates/cloth', to: 'templates#cloth'
  get 'templates/shoe', to: 'templates#shoe'
  get 'templates/bag', to: 'templates#bag'
  get 'templates/shopping', to: 'templates#shopping'
  get 'templates/learnhub', to: 'templates#learnhub'
  get 'templates/english', to: 'templates#english'
  get 'templates/artistry', to: 'templates#artistry'

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
