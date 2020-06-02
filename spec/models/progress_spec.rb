require 'rails_helper'

RSpec.describe Progress, type: :model do
  describe 'Factories' do
    context 'Valid factory' do
      subject { build(:progress) }
      specify { should be_valid }
      specify { is_expected.to be_mongoid_document }
    end
    context 'Invalid factory' do
      subject { build(:invalid_progress) }
      specify { is_expected.not_to be_valid }
    end
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:course).of_type(Course) }
    it { is_expected.to belong_to(:lesson).of_type(Lesson) }
    it { is_expected.to belong_to(:enrollment).of_type(Enrollment) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:course_id) }
    it { should validate_presence_of(:lesson_id) }
    it { should validate_presence_of(:enrollment_id) }
    it { should validate_presence_of(:status) }
  end

  describe 'Callbacks' do
  end

  describe 'ClassMethods' do
  end

  describe 'InstanceMethods' do
  end
end
