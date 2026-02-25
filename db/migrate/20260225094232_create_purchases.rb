class CreatePurchases < ActiveRecord::Migration[8.1]
  def change
    create_table :purchases do |t|
      t.integer :buyer_id
      t.references :ebook, null: false, foreign_key: true
      t.decimal :amount
      t.decimal :seller_commission

      t.timestamps
    end
  end
end
