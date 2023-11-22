class CreateCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :courses do |t|
      t.string :course_title
      t.string :description
      t.decimal :price
      t.integer :number_of_lectures
      t.references :difficulty, null: false, foreign_key: true
      t.integer :course_length
      t.references :category, null: false, foreign_key: true
      t.datetime :publish_date

      t.timestamps
    end
  end
end
