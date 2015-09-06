class RenameRecordsSubCategoryToSubcategory < ActiveRecord::Migration
  def change
    rename_column :record_table, :sub_category, :subcategory
  end
end
