class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:home, :home] 

  # ... rest of your ApplicationController code ...
end