class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currency_table do |t|
      t.string :currency_code
      t.decimal :rate, :precision => 16, :scale => 6, null: false
      t.string :currency_remark
      t.integer :sequence_status, null: false
      t.string :flag_path, null: false
      t.integer :order_no
      t.integer :user_id
      t.boolean :is_delete, default: false
      t.datetime :update_time, null: false
      
      t.timestamps
    end
    add_index :currency_table, :currency_code
    add_index :currency_table, :user_id
  end
end
