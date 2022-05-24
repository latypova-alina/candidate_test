module ManageOrdersHelper
  def process_orders(orders, error)
    orders.each do |order|
      @order = order

      yield
    end
  rescue
    log(I18n.t(error, order_id: @order.id))
  end
end
