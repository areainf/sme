class ChangeReceiptsInDocument < ActiveRecord::Migration
  def change
    remove_column :documents, :recipients_ids
    remove_column :documents, :senders_ids

  end
end
