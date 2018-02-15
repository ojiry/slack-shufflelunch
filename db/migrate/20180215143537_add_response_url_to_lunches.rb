class AddResponseUrlToLunches < ActiveRecord::Migration[5.2]
  def change
    add_column :lunches, :response_url, :string
    execute "UPDATE lunches SET response_url = 'http://example.com'"
    change_column_null :lunches, :response_url, false
  end
end
