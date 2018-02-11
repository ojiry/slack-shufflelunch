class ChangeStructureOfLunches < ActiveRecord::Migration[5.2]
  def change
    remove_column :lunches, :team_id
    remove_column :lunches, :team_domain
    remove_column :lunches, :channel_name
    change_column :lunches, :channel_id, 'bigint USING CAST(channel_id AS bigint)'
  end
end
