require "rails_helper"

RSpec.describe Order, type: :model do
  describe "scopes" do
    describe "active" do
      let!(:active_order) { FactoryBot.create(:order, active: true) }
      let!(:not_active_order) { FactoryBot.create(:order, active: false) }

      it "returns only active orders" do
        expect(Order.active).to eq([active_order])
      end
    end

    describe "delivered" do
      let!(:delivered_order) { FactoryBot.create(:order, :delivered) }

      before { create_list(:order, 2) }

      it "returns only delivered orders" do
        expect(Order.delivered).to eq([delivered_order])
      end
    end

    describe "paid" do
      let!(:paid_order) { FactoryBot.create(:order, :paid) }

      before { create_list(:order, 2) }

      it "returns only paid orders" do
        expect(Order.paid).to eq([paid_order])
      end

      context "but the order is already shipped" do
        before { paid_order.update(shipped_at: Time.now) }

        it "does NOT return shipped orders" do
          expect(Order.paid).to be_empty
        end
      end
    end

    describe "not_paid" do
      let!(:not_paid_order) { FactoryBot.create(:order, paid_at: nil) }

      before { create_list(:order, 2, :paid) }

      it "returns only NOT paid orders" do
        expect(Order.not_paid).to eq([not_paid_order])
      end
    end
  end
end
