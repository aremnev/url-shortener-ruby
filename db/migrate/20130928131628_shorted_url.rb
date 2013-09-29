class ShortedUrl < ActiveRecord::Migration
  def change
    create_table :shorted_url do |t|
      t.string :url
      t.integer :follows
      t.timestamps
    end
  end
end
