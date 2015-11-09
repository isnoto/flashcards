class HomeController < ApplicationController
  def index
    if current_user
      redirect_to reviews_path
    end
  end
end
