class AddIncidentNumberInDocument < ActiveRecord::Migration
  def change
    add_column :documents, :indident_number, :string
    add_column :documents, :resolution_number, :string
  end
end
