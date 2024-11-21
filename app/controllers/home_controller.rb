class HomeController < ApplicationController
  # Skip authentication only for the 'home' action
  skip_before_action :authenticate_user!, only: [:home]

  def home
    # Landing page code
  end
end
