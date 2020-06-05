require 'rails_helper'

RSpec.describe Enrollment, type: :model do
  describe 'Factories' do
    context 'Valid factory' do
      subject { build(:enrollment) }
      specify { should be_valid }
      specify { is_expected.to be_mongoid_document }
    end
    context 'Invalid factory' do
      subject { build(:invalid_enrollment) }
      specify { is_expected.not_to be_valid }
    end
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:payment).of_type(Payment) }
    it { is_expected.to belong_to(:learner).of_type(User) }
    it { is_expected.to belong_to(:course).of_type(Course) }
    it { is_expected.to have_many(:progresses).of_type(Progress) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:reference) }
  end

  describe 'Callbacks' do
  end

  describe 'ClassMethods' do
  end

  describe 'InstanceMethods' do
  end
end
