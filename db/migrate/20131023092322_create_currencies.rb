class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currency_table do |t|
      t.string :currency_code
      t.decimal :rate, :precision => 16, :scale => 2
      t.string :currency_remark
      t.integer :sequence_status
      t.string :flag_path
      t.integer :order_no
      t.integer :user_id
      t.boolean :is_delete
      t.datetime :update_time
      
      t.timestamps
    end
    add_index :currency_table, :currency_code
  end
end
