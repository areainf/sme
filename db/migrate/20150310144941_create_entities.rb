class CreateEntities < ActiveRecord::Migration
  def change
    create_table :entities do |t|
      t.references :people, index: true
      t.references :positions, index: true
      t.references :dependencies, index: true
      t.boolean :active
      t.references :user, index: true

      t.timestamps
    end
  end
end
