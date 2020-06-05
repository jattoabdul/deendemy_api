class Assessment < Lesson
  # Fields
  field :questions, type: Array, default: []
  # each question in questions SCHEMA => { :type, :text, choices: [:value, :is_correct] }
  # question.type enum => [freeText, oneChoice, multiChoice, rating]

  # Associations

  # Validations

  # Hooks/Callbacks
  after_create do
    Event.create(name: 'assessment.created', eventable: self, data: serialize)
  end

  # Methods
end
