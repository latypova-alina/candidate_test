class Report
  #
  # This function sends an email to the line manager,
  # containing all the counts of the orders that have been delivered, shipped
  # and all the counts of the unpaid invoices
  # Please, fix eventual errors, implement what's missing, eventually refactor and optimise
  #
  # @return [<Type>] <description>
  #
  def self.send_to_line_manager
    get_all_the_delivered_orders
    get_all_the_shipped_orders
    get_all_the_unpaid_invoices

    send_all
  end

  def send_all_the_delivered_orders
    Order.where("delivered_at > ?", Date.yesterday.at_midnight).group_by do |order| 
      order.customer.map do |customer, orders|
        [customer.id, orders.count]
      end
    end.to_h
  end

  # Please, implement
  def send_all_the_shipped_orders

  end

  # Please, implement
  def send_all_the_unpaid_invoices

  end

  # Do not implement!
  def send_all
    # Remote Call to the email provider    
    # NOTE: this method connects over the network to our invoicing system and could throw a Timeout::Error
  end
end