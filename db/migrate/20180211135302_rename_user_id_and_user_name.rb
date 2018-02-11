class RenameUserIdAndUserName < ActiveRecord::Migration[5.2]
  def change
    remove_index :users, :user_id
    rename_column :users, :user_id, :slack_id
    rename_column :users, :user_name, :username
    add_index :users, :slack_id, unique: true
  end
end
