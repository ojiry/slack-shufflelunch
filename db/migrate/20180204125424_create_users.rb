class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :user_id, index: { unique: true }, null: false
      t.string :user_name, null: false

      t.timestamps
    end
  end
end
