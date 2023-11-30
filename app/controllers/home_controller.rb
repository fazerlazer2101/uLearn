class HomeController < ApplicationController
  # root_path
  def index
    @courses = Course.all


  end
end
