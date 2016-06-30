class AdminController < ApplicationController

  before_filter :authorize, :authorize_admin_user
  helper_method :redirect_to_return_to_or_default_path

  private

  def authorize_admin_user
    deny_access unless current_user.try(:is_admin?)
  end

  def store_return_to(return_to=nil)
    session[:return_to] = return_to.present? ? return_to : request.fullpath
  end

  def redirect_to_return_to_or_default(default)
    url = session[:return_to] || default
    session[:return_to] = nil
    redirect_to url
  end

  def redirect_to_return_to_or_default_path(default)
    session[:return_to] || default
  end

end
