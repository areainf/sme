class AddUserInMasterUnits < ActiveRecord::Migration
  def change
    add_reference :master_units, :user, index: true
  end
end
