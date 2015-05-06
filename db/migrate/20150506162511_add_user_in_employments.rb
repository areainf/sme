class AddUserInEmployments < ActiveRecord::Migration
  def change
    add_reference :employments, :user, index: true
  end
end
