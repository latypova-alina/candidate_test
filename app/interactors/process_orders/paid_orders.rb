require "product_carrier"

module ProcessOrders
  class PaidOrders
    include Interactor
    include ManageOrdersHelper

    delegate :simulate, :paid_orders, to: :context

    def call
      return if simulate

      context.paid_orders ||= Order.paid

      ship

      paid_orders.update_all({ shipped_at: Time.now })
    end

    private

    def ship
      process_orders(paid_orders.includes(:product, :customer), "ship_error_message") do
        @order.product.ship_for(@order.customer)
      end
    end
  end
end
