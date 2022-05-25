require "invoice_sender"
require "payment_reminder"

module ProcessOrders
  class NotPaidOrders
    include Interactor
    include ManageOrdersHelper
    include ApplicationHelper

    delegate :not_paid_orders, :new_orders, :old_orders, :simulate, to: :context

    def call
      context.not_paid_orders = Order.not_paid
      context.new_orders = new_orders_query
      context.old_orders = old_orders_query

      process_new_orders
      process_old_orders
    end

    private

    def new_orders_query
      not_paid_orders.where("created_at > ?", Date.today.at_midnight)
    end

    def old_orders_query
      not_paid_orders.where.not(id: new_orders)
    end

    def process_new_orders
      process_orders(
        new_orders.includes(:customer),
        "invoice_error_message"
      ) { send_invoice(@order) }
    end

    def process_old_orders
      process_orders(
        old_orders.includes(:customer),
        "reminder_error_message"
      ) { send_reminder(@order) }
    end

    def send_invoice(order)
      order.customer.send_invoice(order) unless simulate

      Rails.logger.info(I18n.t("invoice_sent", customer_id: order.customer_id))
    end

    def send_reminder(order)
      PaymentReminder.new(order).send

      Rails.logger.info(I18n.t("reminder_sent", customer_id: order.customer_id))
    end
  end
end
