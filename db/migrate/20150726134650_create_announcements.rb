class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.string :title
      t.text :content
      t.string :category
      t.string :locale

      t.timestamps
    end
    add_index :announcements, [:category, :created_at]
    add_index :announcements, [:locale, :created_at]
  end
end
