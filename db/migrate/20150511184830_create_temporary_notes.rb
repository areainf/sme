class CreateTemporaryNotes < ActiveRecord::Migration
  def change
    create_table :temporary_notes do |t|

      t.timestamps
    end
  end
end
