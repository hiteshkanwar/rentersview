class UserMailer < ActionMailer::Base
  default from: "from@example.com"
  def welcome_user(user,add)
    @user = user.first_name
    @message = add.message
    mail(:to => user.email, :subject => "Successfully added your add on RentersView")
  end
end
