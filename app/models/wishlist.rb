class Wishlist
  include Mongoid::Document
  include Mongoid::Timestamps
  include Eventable
  include Notifiable
  include Serializable

  # Fields
  field :user_id, type: BSON::ObjectId

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
    items << course_object
  end

  def remove(course_object)
    items.delete(course_object)
  end

  def find_item(course_object)
    return nil if items.blank?
    items.find(course_object)
  end
end
