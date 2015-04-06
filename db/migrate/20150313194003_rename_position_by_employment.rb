class RenamePositionByEmployment < ActiveRecord::Migration
  def change
    rename_table :positions, :employments
    rename_column :entities, :position_id, :employment_id
  end
end
