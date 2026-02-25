# Preview all emails at http://localhost:3000/rails/mailers/purchase_mailer
class PurchaseMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/purchase_mailer/seller_notification
  def seller_notification
    PurchaseMailer.seller_notification
  end

  # Preview this email at http://localhost:3000/rails/mailers/purchase_mailer/stats_notification
  def stats_notification
    PurchaseMailer.stats_notification
  end
end
