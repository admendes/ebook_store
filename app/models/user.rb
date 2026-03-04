class User < ApplicationRecord
  has_many :ebooks, dependent: :destroy
  has_many :purchases, foreign_key: :buyer_id, dependent: :destroy
  has_many :purchased_ebooks, through: :purchases, source: :ebook
  has_one_attached :profile_image

  has_secure_password validations: false

  validates :password, length: { minimum: 6 }, if: -> { new_record? || password.present? }

  ROLES = %w[seller buyer].freeze
  STATUSES = %w[enabled disabled].freeze

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, inclusion: { in: ROLES }
  validates :status, inclusion: { in: STATUSES }

  def seller?
    role == "seller"
  end

  def buyer?
    role == "buyer"
  end

  def enabled?
    status == "enabled"
  end

  def enable!
    update_column(:status, "enabled")
  end

  def disable!
    update_column(:status, "disabled")
  end
end
