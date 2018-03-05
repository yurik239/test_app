class CreateSuppliers < ActiveRecord::Migration[5.1]
  def change
    create_table :suppliers do |t|
      t.string :sup_code
      t.string :sup_name

      t.timestamps
    end
  end
end
