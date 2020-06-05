require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe 'Factories' do
    context 'Valid factory' do
      subject { build(:cart) }
      specify { should be_valid }
      specify { is_expected.to be_mongoid_document }
    end
    context 'Invalid factory' do
      subject { build(:invalid_cart) }
      specify { is_expected.not_to be_valid }
    end
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:user).of_type(User) }
    it { is_expected.to have_and_belong_to_many(:items).of_type(Course) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:user) }
    it { should validate_uniqueness_of(:user) }
  end

  describe 'Callbacks' do
  end

  describe 'ClassMethods' do
  end

  describe 'InstanceMethods' do
    describe '#add' do
      let(:course) { create(:course) }
      let(:user) { create(:user, :without_cart) }
      let(:cart) { create(:cart, user: user) }

      it 'should return new cart with course in it' do
        expect(cart.items.length).to eql(0)
        cart.add(course)
        cart.save
        expect(cart.items.first.id).to eql(course.id)
        expect(cart.items.length).to eql(1)
      end
    end

    describe '#remove' do
      let(:course) { create(:course) }
      let(:user) { create(:user, :without_cart) }
      let(:cart) { create(:cart, user: user) }

      it 'should remove added course and return and empty cart' do
        cart.add(course)
        cart.save
        expect(user.cart.items.length).to eql(1)
        cart.remove(course)
        cart.save
        expect(user.cart.items.length).to eql(0)
      end
    end

    describe '#reset_cart' do
      let(:user) { create(:user, :without_cart) }
      let(:cart) { create(:cart, :with_items, user: user) }

      it 'should remove added course and return and empty cart with no expiry date' do
        expect(cart.items.length).to eql(2)
        expect(cart.expires_on).not_to be_nil
        cart.reset_cart
        cart.save
        expect(cart.items.length).to eql(0)
        expect(cart.expires_on).to be_nil
      end
    end

    describe '#find_item' do
      let(:course) { create(:course) }
      let(:user) { create(:user, :without_cart) }

      context 'when cart has no items' do
        let(:cart) { create(:cart, user: user) }

        it 'should return nil' do
          expect(cart.items.length).to eql(0)
          expect(cart.find_item(course)).to be_nil
        end
      end

      context 'when course exist in cart' do
        let(:cart) { create(:cart, :with_items, user: user) }

        it 'should return the found course' do
          cart.add(course)
          cart.save
          expect(cart.items.length).to eql(3)
          expect(cart.find_item(course)).to eql(course)
        end
      end
    end

    describe '#sub_total' do
      let(:course) { create(:course) }
      let(:user) { create(:user, :without_cart) }
      let(:cart) { create(:cart, user: user) }

      it 'should return sum of cart items' do
        cart.add(course)
        cart.save
        expect(cart.items.length).to eql(1)
        expect(cart.sub_total).to eql(course.price)
      end
    end
  end
end
