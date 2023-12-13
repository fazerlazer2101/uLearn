class ApplicationController < ActionController::Base
  before_action :set_all_categories

  private

  def set_all_categories
    @all_categories = Category.all
  end
end
