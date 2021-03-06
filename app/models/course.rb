class Course
  include Mongoid::Document
  include Mongoid::Timestamps
  include Eventable
  include Notifiable
  include Serializable
  extend Enumerize

  # Fields
  field :title, type: String
  field :subtitle, type: String
  field :tutor_id, type: BSON::ObjectId
  field :label_id, type: BSON::ObjectId
  field :introduction_id, type: BSON::ObjectId
  enumerize :type, in: %i(free paid), default: :paid, predicates:  true
  field :price_pence, type: Integer, default: 0
  field :currency_iso, type: String, default: Money.default_currency.iso_code
  enumerize :status, in: %i(draft approval approved rejected archived), default: :draft, predicates: true, scope: :shallow
  field :copy_text, type: Mongoid::Boolean, default: true
  field :seo, type: Hash, default: {}
  field :language, type: String, default: 'english' # make enum of supported languages later
  enumerize :level, in: %i(beginner intermediate expert everyone), default: :everyone, predicates: true
  field :configs, type: Array, default: []

  # Validations
  validates_presence_of :title, :price_pence, :currency_iso
  validates_numericality_of :price_pence
  validate :price_cannot_be_zero_for_paid_course
  # TODO: add state machine to guard status transitions

  # Associations
  has_and_belongs_to_many :categories, autosave: true
  belongs_to :tutor, class_name: 'User', foreign_key: 'tutor_id'
  belongs_to :label, class_name: 'Media', foreign_key: 'label_id', required: false, optional: true
  has_many :chapters
  belongs_to :introduction, class_name: 'Lesson', foreign_key: 'introduction_id', required: false, optional: true
  has_many :enrollments
  has_many :ratings

  # Hooks/Callbacks
  after_create do
    Event.create(name: 'course.created', eventable: self, data: serialize)
    Notification.create(recipient: tutor, actor: tutor, action: 'course_created', notifiable: self, data: serialize)
  end

  after_save do
    # TODO: Send a course_approved notification on approval of a course if self.status_changed? and status == 'approved'
    # TODO: Send a course_rejected notification on rejection of a course if self.status_changed? and status == 'rejected'
  end

  # Scopes
  scope :approved, -> { where(status: 'approved') }

  # Methods
  def price
    Money.new(price_pence, currency)
  end

  def price=(value)
    self.price_pence = if value.instance_of?(String) ||  value.instance_of?(Integer)
      value.to_i
    else
      value.cents
    end
  end

  def currency
    Money::Currency.new(currency_iso)
  end

  def price_cannot_be_zero_for_paid_course
    errors.add(:price, 'must have a value greater than zero for a paid course') if price_pence <= 0 && self.type == 'paid'
  end
end
