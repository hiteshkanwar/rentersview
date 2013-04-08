class AddAdIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :ad_id, :integer
  end
end
