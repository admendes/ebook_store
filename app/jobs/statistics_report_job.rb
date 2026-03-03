class StatisticsReportJob < ApplicationJob
  queue_as :low

  def perform
    puts "=== Daily Statistics Report ==="
    puts "Total purchases today: #{Purchase.where(created_at: Time.current.beginning_of_day..Time.current.end_of_day).count}"
    puts "Most purchased ebook: #{Ebook.order(purchase_count: :desc).first&.title}"
    puts "Total revenue today: $#{Purchase.where(created_at: Time.current.beginning_of_day..Time.current.end_of_day).sum(:amount)}"
    puts "Active sellers: #{User.where(role: 'seller', status: 'enabled').count}"
  end
end