class Notifications < ActionMailer::Base
  
  SALES_TEAM = "sales@localhost.com"
  
  default from: "from@example.com"
  
  

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications.info_request_confirmation.subject
  #
  def info_request_confirmation(info_request)
    @info_request = info_request
    mail to: info_request.email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications.info_request_sales_team.subject
  #
  def info_request_sales_team(info_request)
    @info_request = info_request
    mail to: SALES_TEAM
  end
end
