Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations'
  }
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  devise_scope :user do
    get 'users/two_factor_authentication' => 'users/sessions#two_factor_authentication', as: :two_factor_authentication
    get 'users/two_factor_setup' => 'users/registrations#two_factor_setup', as: :two_factor_setup
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  resources :employees do
    resources :tasks, only: [:new, :create, :edit, :update]
  end
    
  get 'employee_dashboard', to: 'dashboards#employee'
  get 'hr_manager_dashboard', to: 'dashboards#hr_manager'
  
  root 'dashboards#redirect_based_on_role'
end
