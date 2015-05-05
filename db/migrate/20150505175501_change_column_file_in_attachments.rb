class ChangeColumnFileInAttachments < ActiveRecord::Migration
  def change
    rename_column :attachments, :file, :filedoc
  end
end
