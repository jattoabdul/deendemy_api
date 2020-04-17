class Event
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :name, type: String
  field :data, type: Object

  belongs_to :eventable, polymorphic: true, required: false
  validates :name, presence: true

  # CABLE_EVENTS = [
  #   # 'model.actioned',
  #   'category.created'
  # ].freeze

  # after_create do
  #   EmitEventJob.perform_async(id, 'Deendemy::ActionCableDispatcher') if CABLE_EVENTS.include?(name)
  # end
end