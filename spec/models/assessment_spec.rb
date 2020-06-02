require 'rails_helper'

RSpec.describe Assessment, type: :model do
  describe 'Factories' do
    context 'Valid factory' do
      subject { build(:assessment) }
      specify { should be_valid }
      specify { is_expected.to be_mongoid_document }
    end
    context 'Invalid factory' do
      subject { build(:invalid_assessment) }
      specify { is_expected.not_to be_valid }
    end
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:chapter).of_type(Chapter) }
    it { is_expected.to belong_to(:content).of_type(Media) }
    it { is_expected.to belong_to(:additional_resource).of_type(Media) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:reference) }
    it { should validate_uniqueness_of(:reference) }
  end

  describe 'Callbacks' do
  end

  describe 'ClassMethods' do
  end

  describe 'InstanceMethods' do
  end
end
