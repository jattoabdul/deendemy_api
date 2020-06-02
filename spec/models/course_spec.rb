require 'rails_helper'

RSpec.describe Course, type: :model do
  describe 'Factories' do
    context 'Valid factory' do
      subject { build(:course) }
      specify { should be_valid }
      specify { is_expected.to be_mongoid_document }
    end
    context 'Invalid factory' do
      subject { build(:invalid_course) }
      specify { is_expected.not_to be_valid }
    end
  end

  describe 'Associations' do
    it { is_expected.to have_and_belong_to_many(:categories).of_type(Category) }
    it { is_expected.to belong_to(:tutor).of_type(User) }
    it { is_expected.to belong_to(:label).of_type(Media) }
    it { is_expected.to have_many(:chapters).of_type(Chapter) }
    it { is_expected.to belong_to(:introduction).of_type(Lesson) }
    it { is_expected.to have_many(:enrollments).of_type(Enrollment) }
    it { is_expected.to have_many(:ratings).of_type(Rating) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:price_pence) }
    it { should validate_presence_of(:currency_iso) }
    it { should validate_numericality_of(:price_pence) }
  end

  describe 'Callbacks' do
  end

  describe 'ClassMethods' do
  end

  describe 'InstanceMethods' do
  end
end
