class Widget < ApplicationRecord
  validates :name, :value_in_cents, :quantity, presence: true
  has_many :sales
  belongs_to :user
end