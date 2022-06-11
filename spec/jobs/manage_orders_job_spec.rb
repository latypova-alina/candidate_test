require "rails_helper"
require "product_carrier"
require "invoice_sender"
require "payment_reminder"

RSpec.describe ManageOrdersJob, type: :job do
  describe "#perform" do
    it "calls for interactors" do
      expect(ProcessOrders::DeliveredOrders).to receive(:call)
      expect(ProcessOrders::NotPaidOrders).to receive(:call).with(simulate: false)
      expect(ProcessOrders::PaidOrders).to receive(:call).with(simulate: false)

      described_class.new.perform
    end
  end
end
