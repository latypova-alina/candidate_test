require "rails_helper"

describe ProcessOrders::NotPaidOrders do
  subject(:call) { described_class.call(simulate: simulate) }

  let(:simulate) { false }
  let!(:paid_order) { FactoryBot.create(:order, :paid) }
  let!(:delivered_order) { FactoryBot.create(:order, :delivered) }
  let!(:new_order) { FactoryBot.create(:order, :recent) }
  let!(:old_order) { FactoryBot.create(:order, :old) }
  let(:payment_reminder) { instance_double(PaymentReminder) }

  before do
    allow(InvoiceSender).to receive(:call)
    allow(PaymentReminder).to receive(:new).with(old_order).and_return(payment_reminder)
    allow(payment_reminder).to receive(:send)
    allow(Rails.logger).to receive(:info).at_least(:once)
  end

  it "sends the invoice for the new orders" do
    expect(InvoiceSender).to receive(:call).with(new_order)

    call

    expect(Rails.logger).to have_received(:info).with("Invoice sent for customer #{new_order.customer_id}").once
  end

  it "sends payment reminder for the old orders" do
    expect(PaymentReminder).to receive(:new).with(old_order)
    expect(payment_reminder).to receive(:send)

    call

    expect(Rails.logger).to have_received(:info).with("Reminder sent for customer #{old_order.customer_id}").once
  end

  context "when simulate is true" do
    let(:simulate) { true }

    it "does NOT send invoice" do
      expect(InvoiceSender).not_to receive(:call).with(new_order)

      call
    end
  end

  context "when InvoiceSender is failed" do
    let(:error_text) { "Invoice sending failed for order #{new_order.id} with Timeout::Error" }

    before do
      allow(InvoiceSender).to receive(:call).with(new_order).and_raise Timeout::Error
      allow(Rails.logger).to receive(:error).at_least(:once)
    end

    it "logs an error" do
      call

      expect(Rails.logger).to have_received(:error).with(error_text).once
    end
  end

  context "when PaymentReminder is failed" do
    let(:error_text) { "Payment reminder is failed for order #{old_order.id} with Timeout::Error" }

    before do
      allow(PaymentReminder).to receive(:new).with(old_order).and_return(payment_reminder)
      allow(payment_reminder).to receive(:send).and_raise Timeout::Error
      allow(Rails.logger).to receive(:error).at_least(:once)
    end

    it "logs an error" do
      call

      expect(Rails.logger).to have_received(:error).with(error_text).once
    end
  end
end
