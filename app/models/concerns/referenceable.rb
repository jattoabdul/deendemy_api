module Referenceable
  extend ActiveSupport::Concern

  included do
    before_validation :set_reference, on: :create
  end

  # Sets a short, unique reference ID
  def set_reference
    self.reference = loop do
      # ref = SecureRandom.hex(3)
      ref = SecureRandom.uuid
      break ref unless self.class.exists?(reference: ref)
    end
  end
end
