# frozen_string_literal: true

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Locker
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

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  # Custom User Attributes
  field :first_name,   type: String
  field :last_name,   type: String
  field :country,   type: String # validate must exist
  field :zip,   type: String # validate to have > 5 or <=10 characters
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

  # Hooks/Callbacks
  before_validation do
    self.uid = email if uid.blank?
  end
  after_create do
    Event.create(name: 'user.created', eventable: self, data: serialize)
  end

  # Validations
  validates :zip, length: { within: 5..10 }
  validates :country, :first_name, :last_name, presence: true

  # Include default devise modules. Others available are:
  # , :confirmable, :trackable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :confirmable, :validatable
  include DeviseTokenAuth::Concerns::User

  index({ email: 1 }, { name: 'email_index', unique: true, background: true })
  index({ reset_password_token: 1 }, { name: 'reset_password_token_index', unique: true, sparse: true, background: true })
  index({ confirmation_token: 1 }, { name: 'confirmation_token_index', unique: true, sparse: true, background: true })
  index({ uid: 1, provider: 1}, { name: 'uid_provider_index', unique: true, background: true })
  # index({ unlock_token: 1 }, { name: 'unlock_token_index', unique: true, sparse: true, background: true })

  # Added as a hack to avoid the error on create
  def saved_change_to_attribute?(attr_name, **options)
    true
  end
end
