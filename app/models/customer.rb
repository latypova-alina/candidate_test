require "invoice_sender"

class Customer < ApplicationRecord
  has_many :orders, dependent: :destroy

  def send_invoice(order)
    InvoiceSender.call(order)
  end
end
