require "rails_helper"

describe ProcessOrders::PaidOrders do
  subject(:call) { described_class.call(simulate: simulate) }
  let(:simulate) { false }

  let!(:paid_order) { FactoryBot.create(:order, :paid) }
  let!(:delivered_order) { FactoryBot.create(:order, :delivered) }

  before { allow(ProductCarrier).to receive(:deliver) }

  it "ships the paid orders" do
    expect(ProductCarrier).to receive(:deliver).with(
      paid_order.product, paid_order.customer.address
    )

    expect(call).to be_success
  end

  context "when simulate is true" do
    let(:simulate) { true }

    it "does NOT ship annything" do
      expect(ProductCarrier).not_to receive(:deliver)

      expect(call).to be_success
    end
  end
end
