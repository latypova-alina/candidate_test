module ManageOrdersHelper
  def process_orders(orders, error)
    orders.each do |order|
      @order = order

      yield
    end
  rescue => e
    Rails.logger.error(I18n.t(error, order_id: @order.id, error: e.class))
  end
end
