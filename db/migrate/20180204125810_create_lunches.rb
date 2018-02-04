class CreateLunches < ActiveRecord::Migration[5.2]
  def change
    create_table :lunches do |t|
      t.string :token, null: false
      t.string :team_id, null: false
      t.string :team_domain, null: false
      t.string :channel_id, null: false
      t.string :channel_name, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
