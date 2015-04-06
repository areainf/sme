class ChangeColumnNameEntity < ActiveRecord::Migration
  def change
    rename_column :entities, :people_id, :person_id
    rename_index :entities, :index_entities_on_people_id, :index_entities_on_person_id
  end
end
