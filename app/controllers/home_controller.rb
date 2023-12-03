class HomeController < ApplicationController
  # root_path
  def index
    @courses = Course.page(params[:page]).per(300)
  end
end
