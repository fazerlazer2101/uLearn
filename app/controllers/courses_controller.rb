class CoursesController < ApplicationController
  # root_path
  def index
    @courses = Course.includes(:category).order('RANDOM()').page(params[:page]).per(300).all

    # Filter by category
    @courses = @courses.where(category_id: params[:category_id]) if params[:category_id].present?

    # Search by keyword
    @courses = @courses.where("course_title LIKE ?", "%#{params[:keyword]}%") if params[:keyword].present?
  end

  def show
    @course = Course.includes(:category, :difficulty).find(params[:id])
  end
end
