class AddFieldToImport < ActiveRecord::Migration[5.1]
  def change
	add_column :imports, :body, :text
	add_column :imports, :error, :integer
  end
end
