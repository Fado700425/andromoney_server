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
  end
end
