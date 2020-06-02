require 'rails_helper'

RSpec.describe Wishlist, type: :model do
  describe 'Factories' do
    context 'Valid factory' do
      subject { build(:wishlist) }
      specify { should be_valid }
      specify { is_expected.to be_mongoid_document }
    end
    context 'Invalid factory' do
      subject { build(:invalid_wishlist) }
      specify { is_expected.not_to be_valid }
    end
  end

  describe 'Associations' do
    it { is_expected.to have_and_belong_to_many(:items).of_type(Course) }
    it { is_expected.to belong_to(:user).of_type(User) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_uniqueness_of(:user_id) }
  end

  describe 'Callbacks' do
  end

  describe 'ClassMethods' do
  end

  describe 'InstanceMethods' do
    describe '#add' do
      let(:course) { create(:course) }
      let(:user) { create(:user, :without_wishlist) }
      let(:wishlist) { create(:wishlist, user: user) }

      it 'should return new wishlist with course in it' do
        expect(wishlist.items.length).to eql(0)
        wishlist.add(course)
        wishlist.save
        expect(wishlist.items.first.id).to eql(course.id)
        expect(wishlist.items.length).to eql(1)
      end
    end

    describe '#remove' do
      let(:course) { create(:course) }
      let(:user) { create(:user, :without_wishlist) }
      let(:wishlist) { create(:wishlist, user: user) }

      it 'should remove added course and return and empty cart' do
        wishlist.add(course)
        wishlist.save
        expect(user.wishlist.items.length).to eql(1)
        wishlist.remove(course)
        wishlist.save
        expect(user.wishlist.items.length).to eql(0)
      end
    end

    describe '#find_item' do
      let(:course) { create(:course) }
      let(:user) { create(:user, :without_wishlist) }

      context 'when cart has no items' do
        let(:wishlist) { create(:wishlist, user: user) }

        it 'should return nil' do
          expect(wishlist.items.length).to eql(0)
          expect(wishlist.find_item(course)).to be_nil
        end
      end

      context 'when course exist in cart' do
        let(:wishlist) { create(:wishlist, :with_items, user: user) }

        it 'should return the found course' do
          wishlist.add(course)
          wishlist.save
          expect(wishlist.items.length).to eql(3)
          expect(wishlist.find_item(course)).to eql(course)
        end
      end
    end
  end
end
