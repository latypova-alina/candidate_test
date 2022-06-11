require "spec_helper"
require "rake"

describe "Doctor rake DeleteInvalidOrders" do
  before do
    Rake.application.rake_require "tasks/doctor/delete_invalid_orders"
    Rake::Task.define_task(:environment)
  end

  it "performs DeleteInvalidOrders" do
    expect_any_instance_of(DeleteInvalidOrders).to receive(:perform)

    Rake::Task["candidate_test:doctor:delete_invalid_orders"].execute
  end
end
