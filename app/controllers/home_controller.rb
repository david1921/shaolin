class HomeController < ApplicationController
  def show
    redirect_to current_user_home_path and return if current_user && 
      current_user_home_path != home_path
    render 'index'
  end
end
