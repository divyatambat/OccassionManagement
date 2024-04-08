class User < ApplicationRecord
  DEFAULT_ROLE_NAME = 'CUSTOMER'.freeze

  before_validation :set_default_role, on: :create

  belongs_to :role
  has_many :bookings

  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password_digest, presence: true, on: :create


  def admin?
    role.name == ROLES[:admin]
  end

  def customer?
    role.name == DEFAULT_ROLE_NAME
  end

  # def as_json(options = {})
  #   super(options.merge(except: [:created_at, :updated_at, :role_id, :password_digest]))
  # end

  def as_json(options = {})
    super(options.merge(except: [:created_at, :updated_at, :password_digest]))
  end

  private

  def set_default_role
    self.role ||= Role.find_by(name: DEFAULT_ROLE_NAME)
  end
end
