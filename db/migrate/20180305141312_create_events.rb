class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :slack_id, index: { unique: true }, null: false

      t.timestamps
    end
  end
end
