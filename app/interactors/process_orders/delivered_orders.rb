module ProcessOrders
  class DeliveredOrders
    include Interactor

    def call
      Order.delivered.update_all({ active: false })
    end
  end
end
