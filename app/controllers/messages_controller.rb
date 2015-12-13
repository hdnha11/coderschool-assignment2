class MessagesController < ApplicationController
  before_action :require_login

  def index
    @type = params[:type] || 'incomming'
    if @type == 'incomming'
      @messages = current_user.incomming_messages.order created_at: :desc
    elsif @type == 'outcomming'
      @messages = current_user.outcomming_messages.order created_at: :desc
    else
      @messages = []
    end
  end

  def show
    message_id = params[:id]
    @message = Message.find(message_id)
    @read = @message.read
    unless (@message.recipient == current_user)
      redirect_to messages_path, flash: {error: 'You are not recipient of this message'}
    else
      unless @read
        @message.read = true
        @message.save!
      end
    end
  end
end
