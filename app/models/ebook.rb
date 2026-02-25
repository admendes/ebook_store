class Ebook < ApplicationRecord
  belongs_to :user
  has_many :purchases, dependent: :destroy
  has_many :buyers, through: :purchases, source: :buyer
  has_many :ebook_tags, dependent: :destroy
  has_many :tags, through: :ebook_tags
  has_many :visitors, dependent: :destroy

  has_one_attached :preview_pdf
  has_one_attached :cover_image

  STATUSES = %w[draft pending live].freeze

  validates :title, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, inclusion: { in: STATUSES }
  validates :user_id, presence: true
  validate :preview_pdf_must_be_pdf

  def advance_status!
    case status
    when "draft"   then update!(status: "pending")
    when "pending" then update!(status: "live")
    end
  end

  def live?
    status == "live"
  end

  def draft?
    status == "draft"
  end

  def pending?
    status == "pending"
  end

  private

  def preview_pdf_must_be_pdf
    if preview_pdf.attached? && !preview_pdf.content_type.in?(%w[application/pdf])
      errors.add(:preview_pdf, "must be a PDF file")
    end
  end
end