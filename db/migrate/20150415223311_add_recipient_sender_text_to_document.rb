class AddRecipientSenderTextToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :sender_text, :string
    add_column :documents, :recipient_text, :string
  end
end
