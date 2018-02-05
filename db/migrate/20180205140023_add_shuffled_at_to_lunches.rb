class AddShuffledAtToLunches < ActiveRecord::Migration[5.2]
  def change
    add_column :lunches, :shuffled_at, :datetime
  end
end
