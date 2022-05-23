require "rails_helper"

RSpec.describe ReportsJob, type: :job do
  before do
    allow_any_instance_of(PaymentReminder).to receive(:send)
  end

  describe "#perform" do
    it "sends the report" do
      expect(Report).to receive(:send_to_line_manager)
      described_class.new.perform
    end
  end
end