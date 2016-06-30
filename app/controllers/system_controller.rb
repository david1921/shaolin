class SystemController < ApplicationController

  before_filter :authorize, :authorize_system_user

private

  def authorize_system_user
    deny_access unless current_user.try(:is_system?)
  end
end
