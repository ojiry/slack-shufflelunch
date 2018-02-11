class AddConstraints < ActiveRecord::Migration[5.2]
  def change
    change_column_null :channels, :name, false
    change_column_null :channels, :slack_id, false
    change_column_null :channels, :team_id, false
    change_column_null :teams, :domain, false
    change_column_null :teams, :slack_id, false
    change_column_null :users, :team_id, false

    add_index :channels, :slack_id, unique: true
    add_index :lunches, :channel_id
    add_index :teams, :slack_id, unique: true

    add_foreign_key :lunches, :channels
    add_foreign_key :users, :teams
  end
end
