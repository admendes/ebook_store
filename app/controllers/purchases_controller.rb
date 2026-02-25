class PurchasesController < ApplicationController

  def create
    @ebook = Ebook.find(params[:ebook_id])
    @buyer = User.find(params[:buyer_id])

    unless @ebook.live?
      redirect_to @ebook, alert: "This ebook is not available for purchase."
      return
    end

    unless @buyer.balance >= @ebook.price
      redirect_to @ebook, alert: "Insufficient balance to purchase this ebook."
      return
    end

    commission = (@ebook.price * 0.10).round(2)

    ActiveRecord::Base.transaction do
      @purchase = Purchase.create!(
        buyer_id: @buyer.id,
        ebook_id: @ebook.id,
        amount: @ebook.price,
        seller_commission: commission
      )

      @buyer.update!(balance: @buyer.balance - @ebook.price)

      @ebook.increment!(:purchase_count)

      seller = @ebook.user
      seller.update!(balance: seller.balance + commission)
    end

    PurchaseMailer.seller_notification(@purchase).deliver_now
    PurchaseMailer.stats_notification(@purchase).deliver_now

    redirect_to @ebook, notice: "Ebook purchased successfully!"

  rescue ActiveRecord::RecordInvalid => e
    redirect_to @ebook, alert: "Purchase failed: #{e.message}. No charges were made."
  end

end