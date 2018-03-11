
class Import < ApplicationRecord
	mount_uploader :datafile, DatafileUploader
	paginates_per 10

	def lurl
		"public"+self.datafile.to_s
	end
	
	def filename
		self.datafile.to_s[9..self.datafile.to_s.size]
	end
end
