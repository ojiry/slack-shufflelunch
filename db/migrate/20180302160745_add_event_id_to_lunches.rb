class AddEventIdToLunches < ActiveRecord::Migration[5.2]
  def change
    add_column :lunches, :event_id, :string
  end
end
