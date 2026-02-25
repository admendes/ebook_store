class CreateEbooks < ActiveRecord::Migration[8.1]
  def change
    create_table :ebooks do |t|
      t.string :title
      t.text :description
      t.string :status, default: "draft", null: false
      t.decimal :price, precision: 10, scale: 2
      t.integer :purchase_count, default: 0, null: false
      t.integer :preview_view_count, default: 0, null: false
      t.integer :page_visit_count, default: 0, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
