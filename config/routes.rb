Rails.application.routes.draw do
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
  

  # Root Path (Landing Page)
  root "home#home"

  devise_for :users

  # Authentication Routes
  get "register", to: "users#new", as: :register
  get "login", to: "sessions#new", as: :login
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout

  # Concerns for Shared Routes
  concern :dashboardable do
    get "dashboard", to: "dashboard#index", as: :dashboard
  end

  # Admin Dashboard
  namespace :admin do
    resources :leagues do
      resources :standings, only: [:index]
    end
    resources :teams
    resources :players, only: [:index, :show, :edit, :update, :destroy]
    resources :referees
    resources :matches, only: [:index, :show, :edit, :update, :destroy]
    resources :notifications, only: [:index, :create, :destroy]
    concerns :dashboardable
  end

  # Team Dashboard
  namespace :team do
    resources :players do
      collection do
        get "stats", to: "players#stats"
      end
    end
    resources :matches, only: [:index, :show] do
      member do
        get "team_sheet", to: "matches#team_sheet"
        post "submit_team_sheet", to: "matches#submit_team_sheet"
      end
    end
    resources :profiles, only: [:show, :update]
    concerns :dashboardable
  end

  # Referee Dashboard
  namespace :referee do
    resources :matches, only: [:index, :show] do
      member do
        post "claim", to: "matches#claim"
        post "submit_report", to: "matches#submit_report"
      end
    end
    get "history", to: "matches#history"
    concerns :dashboardable
  end

  # Fans/Viewers Routes
  namespace :fans do
    resources :leagues, only: [:index, :show] do
      resources :standings, only: [:index]
    end
    resources :matches, only: [:index, :show]
    resources :teams, only: [:index]
  end

  # Error Pages
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

  # Catch-All Route for Undefined Paths (Optional)
  match "*path", to: "errors#not_found", via: :all
end
