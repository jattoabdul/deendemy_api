require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'Factories' do
    context 'Valid factory' do
      subject { build(:event) }
      specify { should be_valid }
      specify { is_expected.to be_mongoid_document }
    end
    context 'Invalid factory' do
      subject { build(:invalid_event) }
      specify { is_expected.not_to be_valid }
    end
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:eventable).of_type(Eventable) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'Callbacks' do
    # describe 'after_create' do
    #   let(:category) { create(:category) }
    #   let(:event) { create(:event, name: 'category.created', data: '{}', eventable: category) }
    #
    #   it 'should trigger EmitEventJob for ActionCableDispatcher' do
    #     expect(EmitEventJob).to receive(:perform_async).with(anything, 'IrisNova::ActionCableDispatcher').at_least(:once)
    #     event.save!
    #   end
    #
    #   context 'with non-whitelisted name' do
    #     let(:event) { create(:event, name: 'test', data: '{}', eventable: category) }
    #
    #     it 'should not trigger EmitEventJob for ActionCableDispatcher' do
    #       expect(EmitEventJob).not_to receive(:perform_async).with(anything, 'IrisNova::ActionCableDispatcher')
    #       event.save!
    #     end
    #   end
    # end
  end

  describe 'ClassMethods' do
  end

  describe 'InstanceMethods' do
  end
end
