class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notification, only: [:show, :destroy, :mark_as_read]
  after_action :verify_authorized, except: [:index]
  after_action :verify_policy_scoped, only: [:index]

  # GET /notifications
  def index
    authorize Notification
    @notifications = policy_scope(Notification)
                     .where(user: current_user)
                     .recent
                     .page(params[:page])
                     .per(20)
  end

  # GET /notifications/:id
  def show
    authorize @notification
  end

  # PATCH /notifications/:id/mark_as_read
  def mark_as_read
    authorize @notification
    if @notification.unread?
      @notification.mark_as_read!
      redirect_to notifications_path, notice: 'Notification marked as read.'
    else
      redirect_to notifications_path, alert: 'Notification is already read.'
    end
  end

  # DELETE /notifications/:id
  def destroy
    authorize @notification
    @notification.destroy
    redirect_to notifications_path, notice: 'Notification was successfully deleted.'
  end

  private

  # Sets the @notification instance variable based on the provided ID
  def set_notification
    @notification = current_user.notifications.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to notifications_path, alert: 'Notification not found.'
  end
end
