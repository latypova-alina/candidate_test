require "product_carrier"
require "invoice_sender"
require "payment_reminder"

class ManageOrdersJob < ApplicationJob
  include ApplicationHelper
  queue_as :default

  def perform(*_args)
    perform_delivered_orders
    perform_paid_orders
    perform_unpaid_orders

    Customer.all.each { |customer| log(I18n.t("routine_message", customer_id: customer.id)) }
  end

  private

  def perform_delivered_orders
    Order.delivered.update_all({ active: false })
  end

  def perform_paid_orders
    return if simulate?

    ship
    paid_orders.update_all({ shipped_at: Time.now })
  end

  def perform_unpaid_orders
    process_new_orders
    process_old_orders
  end

  def process_new_orders
    new_orders = not_paid_orders
      .where("created_at > ?", Date.today.at_midnight)
      .includes(:customer)

    process_orders(new_orders, "invoice_error_message") { send_invoice(@order) }
  end

  def process_old_orders
    new_orders = not_paid_orders
      .where("created_at > ?", Date.today.at_midnight)
      .includes(:customer)

    old_orders = not_paid_orders
      .where.not(id: new_orders)
      .includes(:customer)

    process_orders(old_orders, "reminder_error_message") { send_reminder(@order) }
  end

  def ship
    process_orders(paid_orders.includes(:product, :customer), "ship_error_message") do
      @order.product.ship_for(@order.customer)
    end
  end

  def process_orders(orders, error)
    orders.each do |order|
      @order = order

      yield
    end
  rescue
    log(I18n.t(error, order_id: @order.id))
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
