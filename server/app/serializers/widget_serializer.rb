class WidgetSerializer < ActiveModel::Serializer
  attributes :id, :name, :quantity, :value_in_cents
  has_many :sales
end