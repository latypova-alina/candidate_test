class DeleteInvalidOrders
  def perform
    invalid_records.delete_all
  end

  private

  def invalid_records
    Order.where(customer_id: nil).or(Order.where(product_id: nil))
  end
end
