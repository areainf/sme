class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.text :description
      t.date :date
      t.references :document, index: true

      t.timestamps
    end
  end
end
