class Notification < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :notifiable, polymorphic: true, optional: true

  # Validations
  validates :title, :body, presence: true
  validates :notification_type, presence: true, inclusion: { in: %w[assignment update reminder alert] }

  # Scopes
  scope :unread, -> { where(read_at: nil) }
  scope :read, -> { where.not(read_at: nil) }
  scope :recent, -> { order(created_at: :desc) }

  # Callbacks
  after_create :send_notification

  # Instance Methods

  # Marks the notification as read
  def mark_as_read!
    update(read_at: Time.current)
  end

  # Checks if the notification is unread
  def unread?
    read_at.nil?
  end

  private

  # Placeholder method to handle notification delivery
  def send_notification
    # Implement notification delivery logic here (e.g., email, push notification)
    # Example:
    # NotificationMailer.with(notification: self).new_notification_email.deliver_later
  end
end
