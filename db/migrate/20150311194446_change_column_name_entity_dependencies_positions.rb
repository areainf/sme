class ChangeColumnNameEntityDependenciesPositions < ActiveRecord::Migration
  def change
    rename_column :entities, :dependencies_id, :dependency_id
    rename_column :entities, :positions_id, :position_id
    rename_index :entities, :index_entities_on_dependencies_id, :index_entities_on_dependency_id
    rename_index :entities, :index_entities_on_positions_id, :index_entities_on_position_id
  end
end
