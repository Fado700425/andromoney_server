class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currency_table do |t|
      t.string :currency_code
      t.float :rate
      t.string :currency_remark
      t.integer :sequence_status
      t.string :pic
      t.integer :order_no
      t.integer :user_id
      t.boolean :is_delete
      
      t.timestamps
    end
    add_index :currency_table, :currency_code
  end
end
