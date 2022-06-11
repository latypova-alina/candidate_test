require "tasks/support/delete_invalid_orders"

namespace :candidate_test do
  namespace :doctor do
    desc "Remove invalid orders with empty product or customer"
    task delete_invalid_orders: :environment do
      DeleteInvalidOrders.new.perform
    end
  end
end
