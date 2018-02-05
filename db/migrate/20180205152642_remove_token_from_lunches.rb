class RemoveTokenFromLunches < ActiveRecord::Migration[5.2]
  def change
    remove_column :lunches, :token, :string
  end
end
