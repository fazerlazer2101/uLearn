class CategoriesController < ApplicationController
  # GET /categories
  def index
    @categories = Category.includes(:courses).all
  end

  # GET /categories/:id
  def show
    @category = Category.find(params[:id])

    @course_result = Category.includes(:courses).find(params[:id])
                             .courses.page(params[:page]).per(100)
  end
end
