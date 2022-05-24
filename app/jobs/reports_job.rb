require "invoice_sender"
require "payment_reminder"

class ReportsJob < ApplicationJob
  include ApplicationHelper
  queue_as :default

  def perform(*_args)
    Report.send_to_line_manager unless simulate?
    log(I18n.t("manager_routine_message"))
  end

  private

  def simulate?
    Rails.env.development?
  end
end
