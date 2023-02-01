class ConversationsController < ApplicationController

  def index
    @conversations = @user.conversations
    if @conversations.length == 0
      return render json: @conversations, status: :no_content
    else
      return render json: @conversations.map { |conversation| conversation.new_attribute}, status: :ok
    end
  end

  def show
    @conversation = Conversation.find_by_id(params[:id])
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

    return render json: @conversation.new_attribute
  end
end
