class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    # Landing page code
  end
end
