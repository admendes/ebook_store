class DailyStatisticsJob < ApplicationJob
  queue_as :low

  def perform
    ebooks = Ebook.all

    ebooks.each do |ebook|
      puts "Ebook: #{ebook.title}"
      puts "  Purchases: #{ebook.purchase_count}"
      puts "  Page visits: #{ebook.page_visit_count}"
      puts "  Preview views: #{ebook.preview_view_count}"
    end
  end
end