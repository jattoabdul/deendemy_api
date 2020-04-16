require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'Factories' do
    context 'Valid factory' do
      subject { build(:category) }
      specify { should be_valid }
    end
    context 'Valid factory' do
      subject { build(:invalid_category) }
      specify { is_expected.not_to be_valid }
    end
  end

  describe 'Associations' do
  end

  describe 'Validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'Callbacks' do
  end

  describe 'ClassMethods' do
  end

  describe 'InstanceMethods' do
  end
end
