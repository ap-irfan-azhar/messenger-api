class ChangeMessageTableNameToChat < ActiveRecord::Migration[6.1]
  def change
    rename_table :messages, :chats
    remove_column :chats, :content
    add_column :chats, :message, :string
  end
end
