class AddFinalDocumentToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :final_document, :integer
    add_index :documents, :final_document
  end
end
