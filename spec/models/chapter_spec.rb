require 'rails_helper'

RSpec.describe Chapter, type: :model do
  describe 'Factories' do
    context 'Valid factory' do
      subject { build(:chapter) }
      specify { should be_valid }
      specify { is_expected.to be_mongoid_document }
    end
    context 'Invalid factory' do
      subject { build(:invalid_chapter) }
      specify { is_expected.not_to be_valid }
    end
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:course).of_type(Course) }
    it { is_expected.to have_many(:lessons).of_type(Lesson) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:reference) }
    it { should validate_presence_of(:position) }
    it { should validate_presence_of(:course_id) }
  end

  describe 'Callbacks' do
  end

  describe 'ClassMethods' do
  end

  describe 'InstanceMethods' do
  end
end
