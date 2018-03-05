class ChangeColumn < ActiveRecord::Migration[5.1]
  def change
  change_column :imports, :body, :string
  end
end
