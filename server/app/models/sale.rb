class Sale < ApplicationRecord
  validates :quantity, :presence => true
  belongs_to :widget

  def total_sale_in_cents
    widget.value_in_cents * quantity
  end
end