class Item < ApplicationRecord
	validates :sku, presence: true, uniqueness: true
#	belongs_to :supplier
	paginates_per 20
	
	def supplier_name
		if self.supplier_id == nil
			""
		else
			Supplier.find_by(id: self.supplier_id).sup_name
		end
	end
	
end
