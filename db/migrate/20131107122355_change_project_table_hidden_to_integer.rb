class ChangeProjectTableHiddenToInteger < ActiveRecord::Migration
  def change
    change_column :project_table, :hidden, :integer
  end
end
