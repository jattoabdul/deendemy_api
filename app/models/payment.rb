class Payment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Eventable
  include Notifiable
  include Serializable
  extend Enumerize
  # include Referenceable

  # Constant
  PAYMENT_CHANNEL_PAYSTACK = 'paystack'.freeze
  PAYMENT_CHANNEL_PAYPAL = 'paypal'.freeze
  PAYMENT_CHANNEL_STRIPE = 'stripe'.freeze

  # Fields
  field :reference, type: String
  field :user_id, type: BSON::ObjectId
  field :currency_iso, type: String, default: Money.default_currency.iso_code
  field :tax_rate, type: Float, default: 0.0
  field :subtotal_pence, type: Integer, default: 0
  field :tax_pence, type: Integer, default: 0
  field :total_pence, type: Integer, default: 0
  field :status, type: Mongoid::Boolean
  enumerize :processor, in: [PAYMENT_CHANNEL_PAYSTACK, PAYMENT_CHANNEL_PAYPAL, PAYMENT_CHANNEL_STRIPE], predicates: true
  field :comment, type: String
  field :paid_at, type: Time, default: ->{ Time.now }

  # Associations
  has_many :enrollments
  belongs_to :user

  # Validations
  validates_presence_of :reference, :user_id
  # TODO: validate numericality - greater than or equal-to zero for number fields

  # Hooks/Callbacks
  after_create do
    Event.create(name: 'payment.created', eventable: self, data: serialize)
    Notification.create(recipient: user,
                        action: 'payment_created', notifiable: self, data: serialize)
  end

  # Methods
  def subtotal
    Money.new(subtotal_pence, currency)
  end

  def subtotal=(value)
    self.subtotal_pence = if value.instance_of?(String) || value.instance_of?(Integer)
      value.to_i
    else
      value.cents
    end
  end

  def tax
    Money.new(tax_pence, currency)
  end

  def tax=(value)
    self.tax_pence = if value.instance_of?(String) || value.instance_of?(Integer)
      value.to_i
    else
      value.cents
    end
  end

  def total
    Money.new(total_pence, currency)
  end

  def total=(value)
    self.total_pence = if value.instance_of?(String) || value.instance_of?(Integer)
      value.to_i
    else
      value.cents
    end
  end

  def currency
    Money::Currency.new(currency_iso)
  end
end
