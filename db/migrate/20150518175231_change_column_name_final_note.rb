class ChangeColumnNameFinalNote < ActiveRecord::Migration
  def change
    rename_column :documents, :final_document, :final_document_id
  end
end
