class CreatePrefs < ActiveRecord::Migration
  def change
    create_table :prefs do |t|
      t.string :key
      t.string :value
      t.integer :user_id
      t.boolean :is_delete
    end
  end
end
