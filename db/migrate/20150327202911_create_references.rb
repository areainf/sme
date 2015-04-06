class CreateReferences < ActiveRecord::Migration
  def change
    create_table :references do |t|
      t.references :document, index: true
      t.references :entity, index: true
      t.string :type

      t.timestamps
    end
  end
end
