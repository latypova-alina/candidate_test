require "rails_helper"

describe ProcessOrders::DeliveredOrders do
  subject(:call) { described_class.call }

  let!(:paid_order) { FactoryBot.create(:order, :paid) }
  let!(:delivered_order) { FactoryBot.create(:order, :delivered) }

  it "closes the orders that are shipped" do
    expect { call }.to change { delivered_order.reload.active }.from(
      true
    ).to(false)
  end
end
