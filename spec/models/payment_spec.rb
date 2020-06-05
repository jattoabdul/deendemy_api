require 'rails_helper'

RSpec.describe Payment, type: :model do
  describe 'Factories' do
    context 'Valid factory' do
      subject { build(:payment) }
      specify { should be_valid }
      specify { is_expected.to be_mongoid_document }
    end
    context 'Invalid factory' do
      subject { build(:invalid_payment) }
      specify { is_expected.not_to be_valid }
    end
  end

  describe 'Associations' do
    it { is_expected.to have_many(:enrollments).of_type(Enrollment) }
    it { is_expected.to belong_to(:user).of_type(User) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:reference) }
    it { should validate_presence_of(:user_id) }
  end

  describe 'Callbacks' do
  end

  describe 'ClassMethods' do
  end

  describe 'InstanceMethods' do
  end
end
