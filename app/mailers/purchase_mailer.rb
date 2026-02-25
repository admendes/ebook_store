class PurchaseMailer < ApplicationMailer

  def seller_notification(purchase)
    @purchase = purchase
    @ebook = purchase.ebook
    @seller = @ebook.user
    @commission = purchase.seller_commission

    mail(
      to: @seller.email,
      subject: "You sold #{@ebook.title}! Commission: $#{@commission}"
    )
  end

  def stats_notification(purchase)
    @purchase = purchase
    @ebook = purchase.ebook
    @seller = @ebook.user

    mail(
      to: @seller.email,
      subject: "Stats update for #{@ebook.title}"
    )
  end

end