class Conversation < ApplicationRecord
  has_many :conversation_users
  has_many :users, through: :conversation_users
  has_many :chats

  def new_attribute
    {
      id: self.id,
      with_user: self.with_user,
      last_message: self.chats.last.new_attribute,
      unread_count: self.unread_count,
    }
  end

  def with_user
    {
      id: self.users.first.id,
      name: self.users.first.name,
      photo_url: self.users.first.photo_url,
    }
  end

  def unread_count
    self.chats.where(is_read: false).count
  end
end
