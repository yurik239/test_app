class Supplier < ApplicationRecord
	validates :sup_code, presence: true, uniqueness: true
#	has_many :items
	paginates_per 20
end
