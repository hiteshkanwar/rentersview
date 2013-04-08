class UserMailer < ActionMailer::Base
  default from: "from@example.com"
  def welcome_user(message,ad)
    @user = message.receiver.first_name
    @subject = message.sender.name + ' sent you a message for your ad'
    @ad_message = ad.message
    @message = message.content
    mail(:to => message.receiver.email, :subject => @subject)
  end
end
