class CreateCoursesInOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :courses_in_orders do |t|
      t.references :order, null: false, foreign_key: true
      t.references :purchased_course, null: false, foreign_key: true

      t.timestamps
    end
  end
end
