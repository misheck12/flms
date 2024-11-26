Rails.application.routes.draw do
  # Root Path (Landing Page)
  root "home#home"

  # Devise Authentication Routes with Custom Path Names and Registrations Controller
  devise_for :users, 
             path: '', 
             path_names: { sign_in: 'login', sign_out: 'logout', registration: 'register' },
             controllers: { registrations: 'registrations' 1  } # Point to your custom controller


  # Dashboard and Admin Routes
  get 'dashboard', to: 'dashboards#show', as: :dashboard
  get 'admin/dashboard', to: 'admin_dashboards#show', as: :admin_dashboard
  get 'team/dashboard', to: 'team_dashboards#show', as: :team_dashboard
  get 'referee/dashboard', to: 'referee_dashboards#show', as: :referee_dashboard

  # Admin Namespace
  namespace :admin do
    resources :leagues do
      resources :standings, only: [:index]
    end

    resources :teams

    resources :players, only: [:index, :show, :edit, :update, :destroy]

    resources :referees

    resources :matches, only: [:index, :show, :edit, :update, :destroy]

    resources :notifications, only: [:index, :create, :destroy]
  end

  # Team Namespace
  namespace :team do
    resources :players, only: [:index, :show, :create, :destroy] do
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
  end

  # Referee Namespace
  namespace :referee do
    resources :matches, only: [:index, :show] do
      member do
        post "claim", to: "matches#claim"
        post "submit_report", to: "matches#submit_report"
      end
    end

    get "history", to: "matches#history"
  end

  # Fans/Viewers Namespace
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