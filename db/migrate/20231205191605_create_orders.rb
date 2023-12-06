class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :customer_info, null: false, foreign_key: true
      t.string :stripe_session_id
      t.date :order_date
      t.decimal :price
      t.decimal :GST
      t.decimal :HST
      t.decimal :PST

      t.timestamps
    end
  end
end
