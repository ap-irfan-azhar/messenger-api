class Chat < ApplicationRecord
  belongs_to :user, foreign_key: "sender_id"
  belongs_to :conversation

  def new_attribute
    {
      id: self.id,
      sender: self.user.new_attribute,
      chat: self.message,
      is_read: self.is_read,
      sent_at: self.created_at
    }
  end

  def self.new_message(sender, receiver, message)
    @conversation = (sender.conversations & receiver.conversations).first
    binding.pry
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
    @chat.is_read = false
    return @chat
  end
end