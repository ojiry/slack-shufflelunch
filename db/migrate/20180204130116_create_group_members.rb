class CreateGroupMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :group_members do |t|
      t.references :group, foreign_key: true, index: false, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
      t.index %i[group_id user_id], unique: true 
    end
  end
end
