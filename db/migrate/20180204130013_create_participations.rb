class CreateParticipations < ActiveRecord::Migration[5.2]
  def change
    create_table :participations do |t|
      t.references :lunch, foreign_key: true, index: false, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
      t.index %i[lunch_id user_id], unique: true 
    end
  end
end
