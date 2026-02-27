namespace :users do
  desc "Disable users who haven't updated their password in 6 months"
  task check_password_expiry: :environment do
    expiry_date = 6.months.ago

    expired_users = User.where(
      "last_password_change < ? OR last_password_change IS NULL",
      expiry_date
    )

    expired_users.each do |user|
      user.update_column(:status, "disabled")
      puts "Disabled user: #{user.email} (last change: #{user.last_password_change || 'never'})"
    end

    puts "Done. #{expired_users.count} user(s) disabled."
  end
end