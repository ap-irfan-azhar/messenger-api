class Chat < ApplicationRecord
  belongs_to :user, foreign_key: "sender_id"
  belongs_to :conversation

  def created_attribute(user)
    with_user = self.conversation.with_user(user)
    {
      id: self.id,
      message: self.message,
      sender: self.user.new_attribute,
      sent_at: self.created_at,
      conversation: {
        id: self.conversation.id,
        with_user: {
          id: with_user.id,
          name: with_user.name,
          photo_url: with_user.photo_url
        }
      }
    }
  end

  def new_attribute
    {
      id: self.id,
      message: self.message,
      sender: self.user.new_attribute,
      sent_at: self.created_at
    }
  end

  def self.new_message(sender, receiver, message)
    @conversation = (sender.conversations & receiver.conversations).first
    if @conversation.nil?
      @conversation = Conversation.new
      @conversation.users << sender
      @conversation.users << receiver
      @conversation.save
    end
    @chat = Chat.new
    @chat.conversation = @conversation
    @chat.message = message
    @chat.user = sender
    return @chat
  end
end