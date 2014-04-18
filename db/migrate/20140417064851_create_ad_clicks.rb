class CreateAdClicks < ActiveRecord::Migration
  def change
    create_table :ad_clicks do |t|
      t.string :uuid
      t.string :email
      t.integer :click_times
      t.integer :ad_id
    end
    add_index :ad_clicks, :ad_id
    add_index :ad_clicks, :uuid
    add_index :ad_clicks, :email
  end
end
