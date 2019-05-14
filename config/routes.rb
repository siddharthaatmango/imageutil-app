Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, :controllers => { :registrations => 'users/registrations' }
  resources :projects do
    resources :folders do
      get :tokenize
    end
  end
  resources :analytics
  resources :messages
  resources :invoices

  match 'media' => 'media#index', via: [:get]
  
  root to: "home#index"
end
