class RemoveColumnfinalDocumentId < ActiveRecord::Migration
  def change
    remove_column :documents, :final_document_id
  end
end
