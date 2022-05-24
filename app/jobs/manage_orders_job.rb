class ManageOrdersJob < ApplicationJob
  include ApplicationHelper
  queue_as :default

  def perform(*_args)
    ProcessOrders::DeliveredOrders.call
    ProcessOrders::NotPaidOrders.call(simulate: simulate?)
    ProcessOrders::PaidOrders.call(simulate: simulate?)
  end

  private

  def simulate?
    ENV["SIMULATE"].present?
  end
end
