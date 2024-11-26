class SessionsController < ApplicationController
  # Include Devise's helpers
  include Devise::Controllers::Helpers

  # Skip authentication for login and registration actions
  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
    # Renders the login form (sessions/new.html.erb)
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.valid_password?(params[:password])
      sign_in(user)
      
      # Redirect based on user role
      redirect_to after_sign_in_path_for(user), notice: 'Logged in successfully.'
    else
      flash.now[:alert] = 'Invalid email or password'
      render :new
    end
  end

  def destroy
    sign_out(current_user)
    redirect_to root_path, notice: 'Logged out successfully.'
  end

  protected

  # Customize the redirect path after sign in
  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_dashboard_path
    elsif resource.team?
      team_dashboard_path
    elsif resource.referee?
      referee_dashboard_path
    else
      dashboard_path
    end
  end
end
