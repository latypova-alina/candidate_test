require "rails_helper"

RSpec.describe Product, type: :model do
  subject { described_class.new }
  it { is_expected.to respond_to(:ship_for) }
end