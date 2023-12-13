class CreateCustomerInfos < ActiveRecord::Migration[7.0]
  def change
    create_table :customer_infos do |t|
      t.string :customer_name
      t.string :phone_number
      t.string :address
      t.references :user, null: false, foreign_key: true
      t.references :province, null: false, foreign_key: true

      t.timestamps
    end
  end
end
