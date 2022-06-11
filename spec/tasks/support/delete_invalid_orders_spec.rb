require "rails_helper"
require "tasks/support/delete_invalid_orders"

describe DeleteInvalidOrders do
  def run
    described_class.new.perform
  end

  describe "#perform" do
    let!(:invalid_order_1) do
      invalid_order_1 = FactoryBot.build(:order, customer: nil)
      invalid_order_1.save(validate: false)
      invalid_order_1
    end
    let!(:invalid_order_2) do
      invalid_order_2 = FactoryBot.build(:order, product: nil)
      invalid_order_2.save(validate: false)
      invalid_order_2
    end
    let!(:valid_orders) { FactoryBot.create_list(:order, 2) }

    it "does not delete records" do
      expect { run }.to change { Order.count }.by(-2)
      expect(Order).not_to exist(invalid_order_1.id)
      expect(Order).not_to exist(invalid_order_2.id)
    end
  end
end
