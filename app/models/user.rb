# frozen_string_literal: true

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Locker
  include Eventable
  include Serializable

  extend Devise::Models #added this line to extend devise model

  field :locker_locked_at, type: Time
  # field :locker_locked_until, type: Time

  locker locked_at_field: :locker_locked_at
        #  locked_until_field: :locker_locked_until

  ## Database authenticatable
  field :email, type: String, default: ''
  field :encrypted_password, type: String, default: ''

  ## Recoverable
  field :reset_password_token,        type: String
  field :reset_password_sent_at,      type: Time
  field :reset_password_redirect_url, type: String
  field :allow_password_change,       type: Boolean, default: false

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  field :confirmation_token,   type: String
  field :confirmed_at,         type: Time
  field :confirmation_sent_at, type: Time
  field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Invitable
  field :invitation_token, type: String
  field :invitation_created_at, type: Time
  field :invitation_sent_at, type: Time
  field :invitation_accepted_at, type: Time
  field :invitation_limit, type: Integer

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  # Custom User Attributes
  field :first_name,   type: String
  field :last_name,   type: String
  field :country,   type: String
  field :zip,   type: String
  # field :time_zone,   type: String, default: 'UTC'
  field :state,   type: String
  field :city,   type: String
  field :street,   type: String

  # Roles and Permissions
  field :roles,   type: Array, default: []

  ## Required
  field :provider, type: String
  field :uid,      type: String, default: ''

  ## Tokens
  field :tokens, type: Hash, default: {}

  # Associations
  has_many :conversations, foreign_key: :sender_id
  has_many :notifications, foreign_key: :recipient_id
  has_many :medias
  has_many :courses, foreign_key: :tutor_id, dependent: :restrict_with_exception
  has_one :cart
  has_one :wishlist
  # has_many :enrollments
  # has_many :courses, class_name: 'Course', through :enrollments
  # belongs_to :learner, class_name: 'User'  # to be added on enrollment

  # Hooks/Callbacks
  before_validation do
    self.uid = email if uid.blank?
  end
  before_save do
    self.roles = roles.map { |role| role.downcase } if roles.any?
    self.provider = 'email' if provider.blank?
  end
  after_create do
    Cart.create(user: self)
    Wishlist.create(user: self)
    Event.create(name: 'user.created', eventable: self, data: serialize)
  end

  # Validations
  validates :zip, length: { within: 5..10 }
  validates :country, :first_name, :last_name, presence: true

  # Include default devise modules. Others available are:
  # , :confirmable, :trackable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :confirmable, :validatable, :invitable
  include DeviseTokenAuth::Concerns::User

  index({ email: 1 }, { name: 'email_index', unique: true, background: true })
  index({ reset_password_token: 1 }, { name: 'reset_password_token_index', unique: true, sparse: true, background: true })
  index({ confirmation_token: 1 }, { name: 'confirmation_token_index', unique: true, sparse: true, background: true })
  index({ uid: 1, provider: 1}, { name: 'uid_provider_index', unique: true, background: true })
  # index({ unlock_token: 1 }, { name: 'unlock_token_index', unique: true, sparse: true, background: true })
  index( { invitation_token: 1 }, { background: true} )
  index( { invitation_by_id: 1 }, { background: true} )

  # Added as a hack to avoid the error on create
  def saved_change_to_attribute?(attr_name, **options)
    true
  end

  def role_is?(role)
    roles.include?(role)
  end

  def after_confirmation
    if confirmed_at_previous_change.first.nil?
      UserMailer.welcome_tutor_email(id.to_s).deliver_later if role_is?('tutor')
      UserMailer.welcome_email(id.to_s).deliver_later if role_is?('learner') && !role_is?('tutor')
      Notification.create(recipient: self, action: 'user_registered', notifiable: self, data: serialize)
    end
  end
end
