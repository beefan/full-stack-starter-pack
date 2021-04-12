Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope '/api' do
    resources :widgets, only: [:index, :show, :create, :update, :destroy]
    resources :sales, only: [:index, :show, :create, :destroy]
  end

  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#logout'
  post '/signup', to: 'sign_ups#create'
end
