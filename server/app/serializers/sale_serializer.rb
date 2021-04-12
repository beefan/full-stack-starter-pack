class SaleSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :total_sale_in_cents
  belongs_to :widget
end