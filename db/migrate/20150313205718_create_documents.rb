class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :description
      t.text :observation
      t.string :code
      t.integer :direction
      t.string :system_status
      t.date :emission_date
      t.datetime :entry_at
      t.string :reference_people
      t.text :recipients_ids
      t.text :senders_ids
      t.string :recipients
      t.string :senders
      t.references :create_user_id, index: true
      t.references :entry_user_id, index: true
      t.string :type

      t.timestamps
    end
  end
end
