class MessagesController < ApplicationController
  before_filter :authenticate_user!

  def index

  end

  def new
    @message = Message.new(receiver_id: params[:to])
  end

  def create
    @message = Message.new(params[:message])
    @message.sender = current_user
    if @message.save
      UserMailer.welcome_user(@message,@message.ad).deliver
      flash[:notice] = 'Message sent successfully.'
      redirect_to root_path
    else
      render :new
    end
  end

  def show

  end
end
