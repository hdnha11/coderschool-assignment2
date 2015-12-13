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

  def new
    @friends = current_user.active_friends + current_user.passive_friends
  end

  def create
    recipient_id = params[:message][:recipient_id]
    content = params[:message][:content]

    if recipient_id.nil? || recipient_id.empty?
      redirect_to new_message_path, flash: {error: 'Cannot send message. You must choose recipient and type content.'}
      return
    end

    message = Message.new
    message.content = content
    recipient = User.find(recipient_id)
    message.recipient = recipient
    message.sender = current_user

    if message.save
      redirect_to messages_path(type: 'outcomming'), flash: {success: "Send message to #{recipient.name} successfully"}
    else
      redirect_to new_message_path, flash: {error: 'Cannot send message. You must choose recipient and type content.'}
    end
  end
end
