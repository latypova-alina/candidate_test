require "product_carrier"

class Product < ApplicationRecord
  def ship_for(customer)
    ProductCarrier.deliver(self, customer.address)
  end
end