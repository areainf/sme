class AddColumnFolderInDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :folder_id, :integer
    add_index :documents, :folder_id
  end
end
