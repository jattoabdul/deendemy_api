require 'rails_helper'

RSpec.describe Conversation, type: :model do
  describe 'Factories' do
    context 'Valid factory' do
      subject { build(:conversation) }
      specify { should be_valid }
      specify { is_expected.to be_mongoid_document }
    end
    context 'Invalid factory' do
      subject { build(:invalid_conversation) }
      specify { is_expected.not_to be_valid }
    end
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:sender).of_type(User) }
    it { is_expected.to belong_to(:receiver).of_type(User) }
    it { is_expected.to have_many(:messages).of_type(Message) }
  end

  describe 'Validations' do
    it { should validate_uniqueness_of(:sender_id).scoped_to(:receiver_id) }
  end

  describe 'Callbacks' do
  end

  describe 'ClassMethods' do
  end

  describe 'InstanceMethods' do
    describe '#recipient' do
      let(:sender) { create(:user) }
      let(:receiver) { create(:user) }
      let(:conversation) { create(:conversation, sender: sender, receiver: receiver) }

      it 'should return the receiver object' do
        expect(conversation.recipient(sender)).to eql(receiver)
      end

      it 'should return the sender object' do
        expect(conversation.recipient(receiver)).to eql(sender)
      end
    end
  end
end
