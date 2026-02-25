class CreateVisitors < ActiveRecord::Migration[8.1]
  def change
    create_table :visitors do |t|
      t.references :ebook, null: false, foreign_key: true
      t.string :ip_address
      t.string :browser
      t.string :location

      t.timestamps
    end
  end
end
