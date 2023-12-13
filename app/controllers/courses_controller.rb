class CoursesController < ApplicationController
  # root_path
  def index
    @courses = Course.includes(:category).order('RANDOM()').page(params[:page]).per(300).all

    # Filter by category
    if params[:category_id].present?
      @courses = @courses.where(category_id: params[:category_id])
      flash.now[:message] = "Showing results for #{Category.find(params[:category_id]).category_name} category."
    end

    # Search by keyword
    if params[:keyword].present?
      @courses = @courses.where("course_title LIKE ?", "%#{params[:keyword]}%")
      flash.now[:message] = "Showing results for courses containing '#{params[:keyword]}'."
    end
  end

  def show
    @course = Course.includes(:category, :difficulty).find(params[:id])
  end
end
