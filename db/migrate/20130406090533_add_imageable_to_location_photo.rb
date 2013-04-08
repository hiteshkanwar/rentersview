class AddImageableToLocationPhoto < ActiveRecord::Migration
  def change
  	 add_column :location_photos, :imageable_id,:integer
     add_column :location_photos,:imageable_type,:string

  end
end
