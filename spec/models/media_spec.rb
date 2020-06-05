require 'rails_helper'

RSpec.describe Media, type: :model do
  describe 'Factories' do
    context 'Valid factory' do
      subject { build(:media) }
      specify { should be_valid }
      specify { is_expected.to be_mongoid_document }
    end
    context 'Invalid factory' do
      subject { build(:invalid_media) }
      specify { is_expected.not_to be_valid }
    end
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:user).of_type(User) }
    it { is_expected.to belong_to(:message).of_type(Message) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:title) }
  end

  describe 'Callbacks' do
  end

  describe 'ClassMethods' do
  end

  describe 'InstanceMethods' do
  end
end
