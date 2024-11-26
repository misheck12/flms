Rails.application.routes.draw do
  # Root Path (Landing Page)
  root "home#home"

  # Devise Authentication Routes with Custom Path Names
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'register'
  }

  # Central Dashboard Route
  get "dashboard", to: "dashboards#show", as: :dashboard

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
