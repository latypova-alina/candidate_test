require "rails_helper"

RSpec.describe Customer, type: :model do
  subject { described_class.new }
  it { is_expected.to respond_to(:send_invoice) }
end