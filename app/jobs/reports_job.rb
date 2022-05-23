require "invoice_sender"
require "payment_reminder"

class ReportsJob < ApplicationJob
  include ApplicationHelper
  queue_as :default

  def perform(*_args)
    Report.send_to_line_manager unless simulate?
    log("Nightly routine for reporting to the line manager...\n")
  end

  private

  def simulate?
    Rails.env.development?
  end
end
