require 'rails_helper'

RSpec.describe Rating, type: :model do
  describe 'Factories' do
    context 'Valid factory' do
      subject { build(:rating) }
      specify { should be_valid }
      specify { is_expected.to be_mongoid_document }
    end
    context 'Invalid factory' do
      subject { build(:invalid_rating) }
      specify { is_expected.not_to be_valid }
    end
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:course).of_type(Course) }
    it { is_expected.to belong_to(:user).of_type(User) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:course_id) }
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:rating) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:is_deleted) }
  end

  describe 'Callbacks' do
  end

  describe 'ClassMethods' do
  end

  describe 'InstanceMethods' do
  end
end
