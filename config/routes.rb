Rails.application.routes.draw do
  devise_for :users, controllers: { 
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'devise/registrations',
    sessions: 'devise/sessions'
  }
  
  resource :cart, only: [:show] do
    post 'add', to: 'carts#add_item', as: :add_to
    delete 'remove/:id', to: 'carts#remove_item', as: :remove_item
  end

  resources :orders do
    collection do
      get 'fail'
    end
  end
  
  # Design System (Dev Rule)
  get 'design_system', to: 'design_system#index'

  resources :products

  # Design Template Previews
  # Dynamic routes for templates
  get 'templates/:template_name', to: 'templates#show', as: :template_show
  get 'templates/:template_name/:sub_page', to: 'templates#sub_page', as: :template_sub_page

  root "pages#home"

  # 공개 페이지
  get "portfolio", to: "pages#portfolio"
  get "contact", to: "pages#contact"
  post "contact", to: "pages#create_quote"
  get "pricing", to: "pages#pricing"
  get "mypage", to: "mypage#index", as: :mypage
  get "debug_error", to: "pages#debug_error"

  # 템플릿 페이지
  resources :design_templates, only: [:index] do
    post 'toggle_like', to: 'likes#toggle', as: :toggle_like
  end
  get 'templates', to: redirect('/design_templates')

  # 어드민 페이지
  namespace :admin do
    root "dashboard#index"
    resources :sessions, only: [:new, :create, :destroy]
    resources :portfolios
    resources :quotes do
      collection do
        delete :bulk_destroy
      end
    end
    resources :design_templates
  end

  # SEO
  get '/robots.txt', to: 'pages#robots'
  get '/sitemap.xml', to: 'pages#sitemap'

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
