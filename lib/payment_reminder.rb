class PaymentReminder
  def initialize(order)
    @order = order
  end

  def send
    # Do not implement
    # NOTE: this method connects over the network to our mail provider and could throw a Timeout::Error
  end
end