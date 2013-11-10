class CreatePrefs < ActiveRecord::Migration
  def change
    create_table :pref_table do |t|
      t.string :key
      t.string :value
      t.integer :user_id
      t.boolean :is_delete, default: false
      t.datetime :update_time

      t.timestamps
    end
    add_index :pref_table,:key
    add_index :pref_table,:user_id
  end
end
