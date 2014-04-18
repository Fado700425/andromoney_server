class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.string :title
      t.string :link
      t.string :pic_link
      t.string :bank_name
    end
  end
end
