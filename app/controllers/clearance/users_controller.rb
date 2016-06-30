class Clearance::UsersController < ApplicationController
  # we don't allow users to sign_up so this contorller
  # overrides the clearance gem users_controller to 
  # remove sign_up fetures
  
  def new
    redirect_to '/sign_in'
  end

  def create
    redirect_to '/sign_in'
  end
end
