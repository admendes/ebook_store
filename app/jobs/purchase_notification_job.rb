class PurchaseNotificationJob < ApplicationJob
  queue_as :default

  def perform(purchase_id)
    purchase = Purchase.find(purchase_id)

    PurchaseMailer.seller_notification(purchase).deliver_now
    PurchaseMailer.stats_notification(purchase).deliver_now
  end
end