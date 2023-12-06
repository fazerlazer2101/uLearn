class CoursesController < ApplicationController
  def show
    @course = Course.includes(:category, :difficulty).find(params[:id])
  end
end
