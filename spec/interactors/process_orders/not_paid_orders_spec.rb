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
  end

  it "sends the invoice for the new orders" do
    expect(InvoiceSender).to receive(:call).with(new_order)
    call
  end

  it "sends payment reminder for the old orders" do
    expect(PaymentReminder).to receive(:new).with(old_order)
    expect(payment_reminder).to receive(:send)
    call
  end

  context "when simulate is true" do
    let(:simulate) { true }

    it "does NOT send invoice" do
      expect(InvoiceSender).not_to receive(:call).with(new_order)
      call
    end
  end
end
