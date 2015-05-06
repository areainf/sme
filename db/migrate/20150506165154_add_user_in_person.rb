class AddUserInPerson < ActiveRecord::Migration
  def change
    add_column :people, :create_user_id, :integer
    add_index :people, :create_user_id
  end
end
