class Ebook < ApplicationRecord
  belongs_to :user
  has_many :purchases, dependent: :destroy
  has_many :buyers, through: :purchases, source: :buyer
  has_many :ebook_tags, dependent: :destroy
  has_many :tags, through: :ebook_tags
  has_many :visitors, dependent: :destroy

  STATUSES = %w[draft pending live].freeze

  validates :title, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, inclusion: { in: STATUSES }

  def transition_to_next_status!
    case status
    when "draft"   then update!(status: "pending")
    when "pending" then update!(status: "live")
    end
  end

  def live?
    status == "live"
  end
end