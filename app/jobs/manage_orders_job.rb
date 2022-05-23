require "product_carrier"
require "invoice_sender"
require "payment_reminder"

class ManageOrdersJob < ApplicationJob
  include ApplicationHelper
  queue_as :default

  def perform(*_args)
    Customer.all.each do |customer|
      @customer = customer
      @orders = customer.orders

      process_delivered_orders
      process_paid_orders
      process_unpaid_orders

      log(log_text)
    end
  end

  private

  def process_delivered_orders
    @orders.delivered.update_all({ active: false })
  end

  def process_paid_orders
    return if simulate?

    paid_orders = @orders.paid

    paid_orders.includes(:product).each do |order|
      order.product.ship_for(@customer)
    end
    paid_orders.update_all({ shipped_at: Time.now })
  end

  def process_unpaid_orders
    @orders.not_paid.each do |order|
      old_order?(order) ? send_invoice(order) : send_reminder(order)
    end
  end

  def old_order?(order)
    order.created_at > Date.today.at_midnight
  end

  def send_invoice(order)
    order.customer.send_invoice(order) unless simulate?
    log("Invoice sent\n")
  end

  def send_reminder(order)
    PaymentReminder.new(order).send
    log("Payment reminder sent\n")
  end

  def log_text
    "Nightly routine for customer #{@customer.id}...\n"
  end

  def simulate?
    ENV["SIMULATE"].present?
  end
end
