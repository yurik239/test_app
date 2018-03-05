class AddIndex < ActiveRecord::Migration[5.1]
  def change
  add_index :suppliers, :sup_code
  end
end
