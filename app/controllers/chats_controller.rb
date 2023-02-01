class ChatsController < ApplicationController

  def create
    sender = @user
    message = params[:message]
    receiver = User.find_by_id(params[:user_id])
    if receiver.nil?
      return render json: {
        message: "receiver did not exist"
      }
    end

    @chat = Chat.new_message(sender, receiver, message)

    if @chat.save
      return render json: @chat.new_attribute, status: :ok
    else
      return render json: @chat.errors, status: :unprocessable_entity
    end
  end
end
