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
    it { is_expected.to have_many(:conversations).of_type(Conversation) }
    it { is_expected.to have_many(:notifications).of_type(Notification) }
    it { is_expected.to have_many(:medias).of_type(Media) }
    it { is_expected.to have_many(:courses).of_type(Course) }
    it { is_expected.to have_many(:enrollments).of_type(Enrollment) }
    it { is_expected.to have_one(:cart).of_type(Cart) }
    it { is_expected.to have_one(:wishlist).of_type(Wishlist) }
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
