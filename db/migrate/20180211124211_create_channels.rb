class CreateChannels < ActiveRecord::Migration[5.2]
  def change
    create_table :channels do |t|
      t.string :slack_id
      t.string :name
      t.references :team, foreign_key: true

      t.timestamps
    end
  end
end
