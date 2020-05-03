class Assessment < Lesson
  # Fields
  field :questions, type: Array, default: []

  # Associations

  # Validations

  # Hooks/Callbacks
  after_create do
    Event.create(name: 'assessment.created', eventable: self, data: serialize)
  end

  # Methods
end
