class AddTemporaryRefToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :temporary_id, :integer
    add_index :documents, :temporary_id
  end
end
