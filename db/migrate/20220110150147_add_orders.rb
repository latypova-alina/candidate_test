class AddOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.integer :customer_id
      t.integer :product_id
      t.boolean :active, default: true
      t.datetime :paid_at
      t.datetime :shipped_at
      t.datetime :delivered_at
      t.timestamps
    end
  end
end
