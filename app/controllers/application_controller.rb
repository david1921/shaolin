class ApplicationController < ActionController::Base
  include Clearance::Authentication
  protect_from_forgery
  clear_helpers
  helper :layout

  # NOTE: Graeme: I added check for production as well, since we need to hide www.bespokeoffers.co.uk for now
  # until we are ready to launch.
  if Rails.env.staging?     
    force_ssl
    http_basic_authenticate_with :name => "songbird", :password => "lookleft", :realm => ""
  elsif Rails.env.production?
    force_ssl
  end

  before_filter :set_eu_cookie
  def set_eu_cookie
    unless request.cookies.key?('EU_COOKIE')
      cookies['EU_COOKIE'] = { value: Time.now.to_s, expires: 100.years.from_now }
    end
  end

  def eu_cookie?
    request.cookies.key?('EU_COOKIE')
  end
  helper_method :eu_cookie?

  def current_user_home_path
    current_user.try(:only_has_merchant_role?) ? home_path : dashboard_index_path
  end
  helper_method :current_user_home_path

  def save_progress?
    params[:commit] == "Save Progress"
  end

private

  def load_test_data?
    params[:test_data] == "1"
  end

  def authorize
    deny_access unless signed_in? && current_user.active?
  end

  def default_pagination_params
    {page: params[:page], per_page: 25}
  end
end

