require 'csv'
require 'stringio'

HEADERS_SKU = ["sku", "sup_code", "add1", "add2", "add3", "add4", "add5", "add6", "price"]
HEADERS_SKU_SID = ["sku", "sup_code", "add1", "add2", "add3", "add4", "add5", "add6", "price", "supplier_id"]
HEADERS_SUP = ["sup_code", "sup_name"]
COL_SEP = "|"
# require 'activerecord-import/base'
# require 'activerecord-import/active_record/adapters/postgresql_adapter'
class Import < ApplicationRecord
	mount_uploader :datafile, DatafileUploader
	paginates_per 20
	
	
	
	def import_file
		@col_sep = "|"
		@err=""
		@ercount = 0
		if self.filename.include? "supplier"
			
			begin
				@res=PostgresUpsert.write Supplier, self.lurl, :header => false, :columns => ["sup_code", "sup_name"], :unique_key => ["sup_code"], :delimiter => COL_SEP
				@err = 'New suppliers imported - ' + @res.inserted.to_s +
				'; Existed suppliers updated - ' + @res.updated.to_s
			rescue
				@err = 'Can not read the file'+self.datafile.filename.to_s+' or file has wrong structure'
				@ercount = 999
			
				
			end
			
		elsif self.filename.include? "sku"
			puts "SKU BEGIN"
			begin
				i_io = StringIO.new
				sup_hash = Supplier.pluck(:sup_code, :id).to_h
				r_n = 0
				r_s = ""
				r_p = ""
			#	items = []
				rr= {}
			#	puts HEADERS_SKU
			#	puts COL_SEP
			#	puts self.lurl
			#	CSV.foreach(self.lurl, :headers => ["sku", "sup_code", "addq", "add2", "add3", "add4", "add5", "add6", "price"], col_sep: COL_SEP) do |r|
				CSV.foreach(self.lurl, :headers => HEADERS_SKU, col_sep: COL_SEP) do |r|
					r_n += 1
					rr = r.to_h
			#		puts rr
			#		puts rr["price"]
					if rr["price"].match(/[^0-9^,^.]/) == nil
			#			puts "step 1"
						
						supplier_id =  sup_hash[rr["sup_code"]]
			#			puts supplier_id 
						if supplier_id != nil
			#				puts "step 2"
							rr = rr.merge({"supplier_id" => supplier_id})
			#				puts "step 3"
							rr["price"] = rr["price"].to_f
							i_io.puts CSV.generate_line(rr.values, col_sep: COL_SEP)
			#				items << rr
			#				puts "step 4"
			#				puts rr
			#				puts r_n
						else
			#				puts"step 2 else"
			#     unknown supplier
							r_s += r_n.to_s + ", "
							@ercount += 1
						end
					
					else
			#			puts "step 1 else"
			
			#   wrong Price format
						r_p += r_n.to_s + ", "
						@ercount += 1
					end
				end
			#	i_io.rewind
			#	puts i_io.read
				i_io.rewind
				@res = PostgresUpsert.write Item, i_io, :header => false, :columns => HEADERS_SKU_SID, :unique_key => ["sku"], :delimiter => COL_SEP
				puts "END"
				@err += 'New items imported - ' + @res.inserted.to_s +
				'; Existed items updated - ' + @res.updated.to_s
				unless r_s.empty? 
					@err += ' Unknown supplier in lines ' + r_s
				end
				unless r_p.empty? 
					@err += ' Wrong <price> format in lines ' + r_s
				end
			#	puts items
			#	puts r_n
			rescue
				@err = 'Can not read the file'+self.datafile.filename.to_s+' or file has wrong structure'
				@ercount = 999
				
			end
		else
			@err = 'File'+self.datafile.filename.to_s+'  has wrong name'
			@ercount = 999
			
		end
		self.update(body: @err, error: @ercount)
		
	end
	def lurl
		"public"+self.datafile.to_s
	end
	def filename
		self.datafile.to_s[9..self.datafile.to_s.size]
	end
end
