class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.string :buyer, limit: 70
      t.string :description, limit: 150
      t.decimal :price, :precision => 8, :scale => 2
      t.integer :amount
      t.string :address, limit: 150
      t.string :provider, limit: 70

      t.timestamps null: false
    end
  end
end
