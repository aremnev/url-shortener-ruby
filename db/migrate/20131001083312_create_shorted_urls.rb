class CreateShortedUrls < ActiveRecord::Migration
  def change
    create_table :shorted_urls do |t|
      t.text :url
      t.integer :follows
      t.belongs_to :user
      t.timestamps
    end
  end
end
