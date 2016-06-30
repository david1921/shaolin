class InfoRequestsController < ApplicationController
  
  def new
    @info_request = build_info_request
  end
  
  def create
    @info_request = build_info_request(params[:info_request])
    if @info_request.save
      send_confirmation_emails(@info_request)
      redirect_to confirmation_info_request_path(@info_request)
    else
      render :new
    end
  end
  
  private 
  
  # Reponsible for building up a new info request
  # based on the given parameters.
  def build_info_request(parameters = nil)
    InfoRequest.new( parameters )
  end
  
  # Responsible for sending out confirmation emails
  # to the requester and the sales team.
  def send_confirmation_emails(info_request)
    Notifications.info_request_sales_team(info_request).deliver
  end
  
end
