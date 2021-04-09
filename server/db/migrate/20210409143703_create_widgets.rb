class CreateWidgets < ActiveRecord::Migration[6.0]
  def change
    create_table :widgets do |t|
      t.string :name
      t.integer :value_in_cents
      t.integer :quantity
      t.belongs_to :user
      t.timestamps
    end
  end
end
