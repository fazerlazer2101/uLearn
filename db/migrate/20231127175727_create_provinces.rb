class CreateProvinces < ActiveRecord::Migration[7.0]
  def change
    create_table :provinces do |t|
      t.string :Province_Name
      t.decimal :GST
      t.decimal :HST
      t.decimal :PST

      t.timestamps
    end
  end
end
