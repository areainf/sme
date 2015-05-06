class AddUserInDependencies < ActiveRecord::Migration
  def change
    add_reference :dependencies, :user, index: true
  end
end
