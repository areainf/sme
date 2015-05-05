class ChangeColumnNameUsersInDocument < ActiveRecord::Migration
  def change
    rename_column :documents, :create_user_id_id, :create_user_id
    rename_index :documents, :index_documents_on_create_user_id_id, :index_documents_on_create_user_id
    rename_column :documents, :entry_user_id_id, :entry_user_id
    rename_index :documents, :index_documents_on_entry_user_id_id, :index_documents_on_entry_user_id
  end
end
