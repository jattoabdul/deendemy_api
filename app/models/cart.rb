class Cart
  include Mongoid::Document
  include Mongoid::Timestamps
  include Eventable
  include Notifiable
  include Serializable

  # Fields
  field :user_id, type: BSON::ObjectId
  field :expires_on, type: Time

  # Associations
  belongs_to :user
  has_and_belongs_to_many :items, class_name: 'Course', inverse_of: nil, validate: false

  # Validations
  validates_presence_of :user_id
  validates_uniqueness_of :user_id

  # Hooks/Callbacks
  # TODO: handle updating new cart item addition - cart item count - via socket or notifications

  # Methods
  def add(course_object)
    self.items << course_object
  end

  def remove(course_object)
    self.items.delete(course_object)
  end

  def reset_cart
    self.items.clear
    self.expires_on = nil
  end

  def find_item(course_object)
    return nil if items.blank?
    self.items.find(course_object)
  end

  def sub_total
    items.map(&:price).sum
  end

  def reset_expiry
    self.expires_on = 60.days.from_now
  end

  def expired?
    return (self.expires_on < Time.now) if self.expires_on
    false
  end

  def seconds_left
    return (self.expires_on - Time.now).round if self.expires_on
    -1
  end
end
