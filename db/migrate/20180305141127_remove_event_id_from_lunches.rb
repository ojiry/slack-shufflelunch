class RemoveEventIdFromLunches < ActiveRecord::Migration[5.2]
  def change
    remove_column :lunches, :event_id, :string
  end
end
