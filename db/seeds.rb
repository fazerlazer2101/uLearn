# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require "csv"
Course.destroy_all
Difficulty.destroy_all
Category.destroy_all

# Reset auto increment
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='courses';")
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='difficulties';")
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='categories';")

filenameDifficulty = Rails.root.join("db/difficulty.csv")
filenameCategory = Rails.root.join("db/categories.csv")
filenameWebDevelopment = Rails.root.join("db/courses-webdevelopment.csv")
filenameBusiness = Rails.root.join("db/courses-business.csv")
filenameDesign = Rails.root.join("db/courses-design.csv")
filenameMusic = Rails.root.join("db/courses-music.csv")

# Reads data
difficulty_data = File.read(filenameDifficulty)
category_data = File.read(filenameCategory)
courses_web_data = File.read(filenameWebDevelopment)
courses_business_data = File.read(filenameBusiness)
courses_design_data = File.read(filenameDesign)
courses_music_data = File.read(filenameMusic)

difficulties = CSV.parse(difficulty_data, headers: true, encoding: "utf-8")
categories = CSV.parse(category_data, headers: true, encoding: "utf-8")
courses_webdev = CSV.parse(courses_web_data, headers: true, encoding: "utf-8")
courses_business = CSV.parse(courses_business_data, headers: true, encoding: "utf-8")
courses_design = CSV.parse(courses_design_data, headers: true, encoding: "utf-8")
courses_music = CSV.parse(courses_music_data, headers: true, encoding: "utf-8")

# Creates difficulty
difficulties.each do |p|
  # Creates difficulty

  course_difficulty = Difficulty.find_by(difficulty: p["difficulty_name"])

  unless course_difficulty&.valid?

    difficulty = Difficulty.create(
      difficulty: p["difficulty_name"]
    )
  end
  Rails.logger.debug "Created #{Difficulty.count} difficulties."
end

# Creates categories
categories.each do |p|
  # Creates categories

  course_category = Category.find_by(category_name: p["categories_name"])

  unless course_category&.valid?

    category = Category.create(
      category_name: p["categories_name"]
    )
  end
  Rails.logger.debug "Created #{Difficulty.count} difficulties."
end

# Courses webdev
courses_webdev.each do |p|
  # Creates courses
  course_web = Course.find_by(course_title: p["course_title"])
  unless Category.exists?(category_name: p["subject"])
    newCategory = Category.create(category_name: p["subject"])
  end
  unless course_web&.valid?

    course = Course.create(
      course_title:       p["course_title"],
      description:        "",
      price:              p["price"],
      number_of_lectures: p["num_lectures"],
      difficulty_id:      Difficulty.where(difficulty: p["level"]).pluck(:id).first,
      course_length:      p["content_duration"],
      category_id:        Category.where(category_name: p["subject"]).pluck(:id).first,
      publish_date:       p["published_timestamp"]
    )
  end
  Rails.logger.debug "Created #{Difficulty.count} difficulties."
end

# Business Finance
courses_business.each do |p|
  # Creates courses
  course_businesses = Course.find_by(course_title: p["course_title"])
  if Category.exists?(category_name: p["subject"]) == false
    newCategory = Category.create(category_name: p["subject"])
  end
  unless course_businesses&.valid?

    course_ = Course.create(
      course_title:       p["course_title"],
      description:        "",
      price:              p["price"],
      number_of_lectures: p["num_lectures"],
      difficulty_id:      Difficulty.where(difficulty: p["level"]).pluck(:id).first,
      course_length:      p["content_duration"],
      category_id:        Category.where(category_name: p["subject"]).pluck(:id).first,
      publish_date:       p["published_timestamp"]
    )
  end
  Rails.logger.debug "Created #{Difficulty.count} difficulties."
end

# # Graphic Design
# courses_design.each do |p|
#   # Creates courses
#   course_designs = Course.find_by(course_title: p["course_title"])
#   unless Category.exists?(category_name: p["subject"])
#     newCategory = Category.create(category_name: p["subject"])
#   end

#   unless course_designs&.valid?

#     course = Course.create(
#       course_title:       p["course_title"],
#       description:        "",
#       price:              p["price"],
#       number_of_lectures: p["num_lectures"],
#       difficulty_id:      Difficulty.where(difficulty: p["level"]).pluck(:id).first,
#       course_length:      p["content_duration"],
#       category_id:        Category.where(category_name: p["subject"]).pluck(:id).first,
#       publish_date:       p["published_timestamp"]
#     )
#   end
#   Rails.logger.debug "Created #{Difficulty.count} difficulties."
# end

# # Courses music
# courses_music.each do |p|
#   # Creates courses
#   course_music_exists = Course.find_by(course_title: p["course_title"])
#   unless Category.exists?(category_name: p["subject"])
#     newCategory = Category.create(category_name: p["subject"])
#   end

#   unless course_music_exists&.valid?

#     course = Course.create(
#       course_title:       p["course_title"],
#       description:        "",
#       price:              p["price"],
#       number_of_lectures: p["num_lectures"],
#       difficulty_id:      Difficulty.where(difficulty: p["level"]).pluck(:id).first,
#       course_length:      p["content_duration"],
#       category_id:        Category.where(category_name: p["subject"]).pluck(:id).first,
#       publish_date:       p["published_timestamp"]
#     )
#   end
#   Rails.logger.debug "Created #{Difficulty.count} difficulties."
# end
