class CreateRecords < ActiveRecord::Migration
  def change
    create_table :record_table do |t|
      
      t.decimal :mount,:precision => 16, :scale => 2
      t.string  :category
      t.string  :subcategory

      t.datetime :date
      t.string :in_payment
      t.string :out_payment
      t.string :remark
      t.string :currency_code
      t.decimal :amount_to_main,:precision => 16, :scale => 2
      t.string :period
      t.string :payee
      t.string :project
      t.string :fee

      t.decimal :in_amount,:precision => 16, :scale => 2
      t.decimal :out_amount
      t.string :in_currency
      t.string :out_currency,:precision => 16, :scale => 2
      
      t.integer :user_id
      t.string :hash_key
      t.boolean :is_delete, default: false
      t.datetime :update_time

      t.timestamps
    end
    add_index :record_table,:hash_key
    add_index :record_table,:user_id
  end
end
