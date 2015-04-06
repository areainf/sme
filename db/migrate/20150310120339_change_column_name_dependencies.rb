class ChangeColumnNameDependencies < ActiveRecord::Migration
  def change
    rename_column :dependencies, :dependency_id, :parent_id

  end
end
