require 'rails_helper'

RSpec.describe LessonDiscussion, type: :model do
  describe 'Factories' do
    context 'Valid factory' do
      subject { build(:lesson_discussion) }
      specify { should be_valid }
      specify { is_expected.to be_mongoid_document }
    end
    context 'Invalid factory' do
      subject { build(:invalid_lesson_discussion) }
      specify { is_expected.not_to be_valid }
    end
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:parent).of_type(LessonDiscussion) }
    it { is_expected.to have_many(:children).of_type(LessonDiscussion) }
    it { is_expected.to belong_to(:sender).of_type(User) }
    it { is_expected.to belong_to(:course).of_type(Course) }
    it { is_expected.to belong_to(:lesson).of_type(Lesson) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:lesson_id) }
    it { should validate_presence_of(:sender_id) }
    it { should validate_presence_of(:course_id) }
  end

  describe 'Callbacks' do
  end

  describe 'ClassMethods' do
  end

  describe 'InstanceMethods' do
  end
end
