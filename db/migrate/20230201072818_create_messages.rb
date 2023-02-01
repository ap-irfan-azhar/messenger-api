class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.integer :sender_id
      t.integer :conversation_id
      t.integer :parent_id
      t.string :message
      t.boolean :is_read

      t.timestamps
    end
  end
end
