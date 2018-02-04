class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.references :lunch, foreign_key: true, index: false, null: false
      t.string :name, null: false

      t.timestamps
      t.index %i[lunch_id name], unique: true 
    end
  end
end
