class CreateShortedUrls < ActiveRecord::Migration
  def change
    create_table :shorted_urls do |t|
      t.string :ulr
      t.integer :follows

      t.timestamps
    end
  end
end
