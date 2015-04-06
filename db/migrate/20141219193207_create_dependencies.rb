class CreateDependencies < ActiveRecord::Migration
  def change
    create_table :dependencies do |t|
      t.string :name
      t.string :description
      t.references :dependency
      t.references :master_unit

      t.timestamps
    end
  end
end
