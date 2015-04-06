class CreateMasterUnits < ActiveRecord::Migration
  def change
    create_table :master_units do |t|
      t.string :name, unique: true

      t.timestamps
    end
  end
end
