class AddPhotoToSubcategory < ActiveRecord::Migration
  def change
  	add_column :subcategory_table, :photo_path, :string
  end
end
