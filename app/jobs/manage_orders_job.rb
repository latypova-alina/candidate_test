require "product_carrier"
require "invoice_sender"
require "payment_reminder"

class ManageOrdersJob < ApplicationJob
  include ApplicationHelper
  include ManageOrderJobHelper
  queue_as :default

  def perform(*_args)
    process_delivered_orders
    process_paid_orders
    process_unpaid_orders

    Customer.all.each { |customer| log(I18n.t("routine_message", customer_id: customer.id)) }
  end

  private

  def process_delivered_orders
    Order.delivered.update_all({ active: false })
  end

  def process_paid_orders
    return if simulate?

    paid_orders.includes(:product, :customer).each do |order|
      order.product.ship_for(order.customer)
    end
    paid_orders.update_all({ shipped_at: Time.now })
  end

  def process_unpaid_orders
    new_orders = not_paid_orders.where("created_at > ?", Date.today.at_midnight)
    old_orders = not_paid_orders.where.not(id: new_orders)

    new_orders.includes(:customer).each do |order|
      send_invoice(order)
    end

    old_orders.includes(:customer).each do |order|
      send_reminder(order)
    end
  end

  def paid_orders
    @_paid_orders ||= Order.paid
  end

  def not_paid_orders
    @_not_paid_orders ||= Order.not_paid
  end

  def send_invoice(order)
    order.customer.send_invoice(order) unless simulate?
    log(I18n.t("invoice_sent"))
  end

  def send_reminder(order)
    PaymentReminder.new(order).send
    log(I18n.t("reminder_sent"))
  end

  def simulate?
    ENV["SIMULATE"].present?
  end
end
