class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.references :user, index: true
      t.text :dependencies
      t.text :employments
      t.boolean :personal_documents, default: true

      t.timestamps
    end
  end
end
