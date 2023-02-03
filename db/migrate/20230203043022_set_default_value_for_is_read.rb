class SetDefaultValueForIsRead < ActiveRecord::Migration[6.1]
  def change
    change_column_default :chats, :is_read, false
  end
end
