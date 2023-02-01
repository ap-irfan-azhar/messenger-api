class ConversationsController < ApplicationController
  before_action :set_conversation, only: [:show, :show_chats]
  def index
    @conversations = @user.conversations
    if @conversations.length == 0
      return render json: @conversations, status: :no_content
    else
      return render json: @conversations.map { |conversation| conversation.new_attribute(@user)}, status: :ok
    end
  end

  def show
    return render json: @conversation.new_attribute(@user)
  end

  def show_chats
    @conversation.read_chats(@user)
    return render json: @conversation.chats.map { |chat| chat.new_attribute}, status: :ok
  end

  private

  def set_conversation
    @conversation = Conversation.find_by_id(params[:id] || params[:conversation_id])
    if @conversation.nil?
      return render json: {
        message: "Conversation not found"
      }, status: :not_found
    end

    if @conversation.conversation_users.exists?(user_id: @user.id) == false
      return render json: {
        message: "you can not open other people's conversation"
      }, status: :unauthorized
    end
  end
end
