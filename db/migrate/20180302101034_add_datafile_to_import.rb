class AddDatafileToImport < ActiveRecord::Migration[5.1]
  def change
	add_column :imports, :datafile, :string
  end
end
