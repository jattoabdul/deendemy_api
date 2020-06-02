require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Factories' do
    context 'Valid factory' do
      subject { build(:user) }
      specify { should be_valid }
      specify { is_expected.to be_mongoid_document }
    end
    context 'Valid factory' do
      subject { build(:invalid_user) }
      specify { is_expected.not_to be_valid }
    end
  end

  describe 'Associations' do
    # it { is_expected.to have_one(:cart).of_type(Cart) }
  end

  describe 'Validations' do
  end

  describe 'Callbacks' do
  end

  describe 'ClassMethods' do
  end

  describe 'InstanceMethods' do
  end
end
