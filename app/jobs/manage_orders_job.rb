require "product_carrier"
require "invoice_sender"
require "payment_reminder"

class ManageOrdersJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Customer.all.each do |customer|
      @logs = "Nightly routine for customer #{customer.id}...\n"

      # All the orders that have been delivered
      customer.orders.where(active: true).where("delivered_at IS NOT NULL").each do |order|
        order.update_attribute(:active, false)
      end

      # All the orders that are paid, but need delivery
      customer.orders.where(active: true).where("paid_at IS NOT NULL AND shipped_at IS NULL").each do |order|
        order.product.ship_for(customer) unless simulate?
        order.update_attribute(:shipped_at, Time.now) unless simulate?
      end

      # All the orders that are not paid
      customer.orders.where(active: true).where("paid_at IS NULL").each do |order|
        if customer.orders.where("created_at > ?", Date.today.at_midnight).any?
          customer.send_invoice(order) unless simulate?
          @logs << "Invoice sent\n"
        else
          PaymentReminder.new(order).send
          @logs << "Payment reminder sent\n"
        end
      end

      puts @logs
    end
  end

  private

  def simulate?
    ENV["SIMULATE"].present?
  end
end
