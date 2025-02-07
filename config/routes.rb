Rails.application.routes.draw do
  resources :directory_links
  root 'pages#home'
  get 'pages/about'

  namespace :admin do
      resources :users
      resources :roles, only: [:index, :show]
      root to: "users#index"
  end

  # devise_for :users
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions => 'users/sessions',
    :passwords => 'users/passwords',
    :confirmations => 'users/confirmations'
   }

  devise_scope :user do
    get 'sign_up', to: 'users/registrations#new'
    get 'sign_in', to: 'users/sessions#new'
    delete 'signout', to: 'users/sessions#destroy'
  end

  get '/dashboard', to: 'dashboard#show', as: 'dashboard'

  resources :users
  resources :purchasers
  resources :vendors
  resources :orders

  resources :table_options

  get '/archived_orders', to: 'orders#archived_index'
  get '/all_orders', to: 'orders#all_orders'

  get '/purchasers_all', to: 'purchasers#show_all'

  #get '/all_ship_orders/:id', to: 'purchasers#show_all'
  get '/search', to: 'searches#index'


  resources :orders do
    resources :attachments do
      delete :destroy_attachment
    end
  end

  resources :purchasers do
    member do
      get :export
      get :deliver
    end
  end



  # Redirects to root if invalid path BUT, fucks up search params
  # match '*path' => redirect('/'), :via => [:get, :post]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
