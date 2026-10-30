class PriceItem < ApplicationRecord
  validates :category, :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  scope :ordered, -> { order(:category, :position, :id) }

  # A nil price means the item is priced individually ("dle dohody").
  def priced_individually?
    price.nil?
  end
end
