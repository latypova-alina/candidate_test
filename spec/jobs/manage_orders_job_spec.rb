require "rails_helper"
require "product_carrier"
require "invoice_sender"
require "payment_reminder"

RSpec.describe ManageOrdersJob, type: :job do
  let!(:order1) { FactoryBot.create(:order, :paid, :shipped, :delivered) }
  let!(:order2) { FactoryBot.create(:order, :paid) }
  let!(:order3) { FactoryBot.create(:order, :recent) }
  let!(:order4) { FactoryBot.create(:order, :old) }

  before do
    allow(ProductCarrier).to receive(:deliver)
    allow(InvoiceSender).to receive(:call)
    allow_any_instance_of(PaymentReminder).to receive(:send)
  end

  describe "#perform" do
    it "closes the orders that are shipped" do
      expect { described_class.new.perform }.to change { order1.reload.active }.from(
        true
      ).to(false)
    end

    it "ships the paid orders" do
      expect(ProductCarrier).to receive(:deliver).with(
        order2.product, order2.customer.address
      )
      described_class.new.perform
    end

    it "sends the invoice for the new orders" do
      expect(InvoiceSender).to receive(:call).with(order3)
      described_class.new.perform
    end

    it "sends payment reminder for the old orders" do
      expect_any_instance_of(PaymentReminder).to receive(:send)
      described_class.new.perform
    end
  end
end