class CreateSales < ActiveRecord::Migration[6.0]
  def change
    create_table :sales do |t|
      t.integer :quantity
      t.belongs_to :widget
    end
  end
end
