require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'Factories' do
    context 'Valid factory' do
      subject { build(:notification) }
      specify { should be_valid }
      specify { is_expected.to be_mongoid_document }
    end
    context 'Invalid factory' do
      subject { build(:invalid_notification) }
      specify { is_expected.not_to be_valid }
    end
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:recipient).of_type(User) }
    it { is_expected.to belong_to(:actor).of_type(User) }
    it { is_expected.to belong_to(:notifiable).of_type(Notifiable) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:action) }
  end

  describe 'Callbacks' do
  end

  describe 'ClassMethods' do
  end

  describe 'InstanceMethods' do
  end
end
