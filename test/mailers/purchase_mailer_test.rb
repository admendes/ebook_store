require "test_helper"

class PurchaseMailerTest < ActionMailer::TestCase
  test "seller_notification" do
    mail = PurchaseMailer.seller_notification
    assert_equal "Seller notification", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "stats_notification" do
    mail = PurchaseMailer.stats_notification
    assert_equal "Stats notification", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
