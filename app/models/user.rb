class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # Roles enumeration
  enum role: { admin: 0, team: 1, referee: 2 }

  # Associations
  has_one :team, dependent: :nullify
  has_one :referee_profile, class_name: 'Referee', dependent: :nullify

  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true, inclusion: { in: roles.keys }

  # Callbacks
  after_initialize :set_default_role, if: :new_record?

  # Scopes
  scope :admins, -> { where(role: :admin) }
  scope :team_managers, -> { where(role: :team) }
  scope :referees, -> { where(role: :referee) }

  # Instance Methods

  # Check if the user is an admin
  def admin?
    role == 'admin'
  end

  # Check if the user is a team manager
  def team?
    role == 'team'
  end

  # Check if the user is a referee
  def referee?
    role == 'referee'
  end

  private

  # Set default role to referee if not specified
  def set_default_role
    self.role ||= :team
  end
end
