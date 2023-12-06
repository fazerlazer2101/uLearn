class HomeController < ApplicationController
  # root_path
  def index
    @courses = Course.includes(:category).order('RANDOM()').page(params[:page]).per(300).all
  end
end
