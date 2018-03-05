class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
		t.string :sku
		t.integer :supplier_id
		t.string :sup_code
		t.string :add1
		t.string :add2
		t.string :add3
		t.string :add4
		t.string :add5
		t.string :add6
		t.float :price

      t.timestamps
    end
	add_index :items, :sup_code
	add_index :items, :supplier_id
	add_index :items, :sku
  end
end
