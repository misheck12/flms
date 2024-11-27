Rails.application.routes.draw do
  # Root Path (Landing Page)
  root "home#home"

  # Devise Authentication Routes with Custom Path Names and Registrations Controller
  devise_for :users, controllers: { registrations: 'registrations' }

  # Dashboard Routes
  get 'dashboard', to: 'dashboards#show', as: :dashboard

  # Admin Dashboard Route
  get 'admin/dashboard', to: 'admin_dashboards#show', as: :admin_dashboard

  # Team Dashboard Route
  get 'team/dashboard', to: 'team_dashboards#show', as: :team_dashboard

  # Referee Dashboard Route
  get 'referee/dashboard', to: 'referee_dashboards#show', as: :referee_dashboard

  # Team Dashboard Routes
  resource :team_dashboard, only: [:show] do
    get 'edit_team_info', to: 'team_dashboards#edit_team_info', as: 'edit_team_info'
    patch 'update_team_info', to: 'team_dashboards#update_team_info', as: 'update_team_info'
    # Add additional custom routes here if needed

    # Player Management
    resources :team_players, only: [:index, :new, :create, :edit, :update, :destroy] do
      collection do
        get 'stats', to: 'players#stats'
      end
    end

    # Match Rosters
    resources :match_rosters, only: [:new, :create, :edit, :update, :destroy]

    # Team Sheets and Formations
    resources :team_sheets, only: [:new, :create, :edit, :update, :destroy]
    resources :formations, only: [:new, :create, :edit, :update, :destroy]

    # Player Performance
    resources :performances, only: [:index, :new, :create, :edit, :update, :destroy]

    # Match Schedules
    resources :team_matches, only: [:index, :show] do
      member do
        get 'team_sheet', to: 'matches#team_sheet'
        post 'submit_team_sheet', to: 'matches#submit_team_sheet'
      end

      resources :schedules, only: [:index, :show]
    end

    # Team Profiles
    resources :team_profiles, only: [:show, :update]
  end

  # Team Management Routes for Users
  resources :teams, only: [:new, :create]

  # Admin Routes (Flattened, No Namespace)
  # Admin Leagues and Standings
  resources :admin_leagues, path: 'admin/leagues', as: 'admin_leagues' do
    resources :admin_standings, path: 'standings', as: 'standings', only: [:index]
  end

  # Admin Teams
  resources :admin_teams, path: 'admin/teams'

  # Admin Players
  resources :admin_players, path: 'admin/players', only: [:index, :show, :edit, :update, :destroy]

  # Admin Referees
  resources :admin_referees, path: 'admin/referees'

  # Admin Matches
  resources :admin_matches, path: 'admin/matches', only: [:index, :show, :edit, :update, :destroy]

  # Admin Notifications
  resources :admin_notifications, path: 'admin/notifications', only: [:index, :create, :destroy]

  # Referee Routes (Flattened, No Namespace)
  # Referee Matches
  resources :referee_matches, path: 'referee/matches', only: [:index, :show] do
    member do
      post 'claim', to: 'referee_matches#claim'
      post 'submit_report', to: 'referee_matches#submit_report'
    end
  end

  # Referee History
  get 'referee/history', to: 'referee_matches#history', as: :referee_history

  # Fans/Viewers Namespace (Remains Intact)
  namespace :fans do
    resources :leagues, only: [:index, :show] do
      resources :standings, only: [:index]
    end

    resources :matches, only: [:index, :show]

    resources :teams, only: [:index]
  end

  # Any additional routes can be added below
end