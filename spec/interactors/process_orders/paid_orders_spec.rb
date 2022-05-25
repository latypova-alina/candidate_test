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

  context "when ProductCarrier raises an error" do
    let(:error_text) { "Shipment is failed for order #{paid_order.id} with Timeout::Error" }

    before do
      allow(ProductCarrier).to receive(:deliver).and_raise Timeout::Error
      allow(Rails.logger).to receive(:error).at_least(:once)
    end

    it "logs an error" do
      call

      expect(Rails.logger).to have_received(:error).with(error_text).once
    end
  end
end
