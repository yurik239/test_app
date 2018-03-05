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
				rr= {}
				CSV.foreach(self.lurl, :headers => HEADERS_SKU, col_sep: COL_SEP) do |r|
					r_n += 1
					rr = r.to_h
					if rr["price"].match(/[^0-9^,^.]/) == nil

						
						supplier_id =  sup_hash[rr["sup_code"]]

						if supplier_id != nil

							rr = rr.merge({"supplier_id" => supplier_id})

							rr["price"] = rr["price"].to_f
							i_io.puts CSV.generate_line(rr.values, col_sep: COL_SEP)

						else

			#     unknown supplier
							r_s += r_n.to_s + ", "
							@ercount += 1
						end
					
					else
			
			#   wrong Price format
						r_p += r_n.to_s + ", "
						@ercount += 1
					end
				end

				i_io.rewind
				@res = PostgresUpsert.write Item, i_io, :header => false, :columns => HEADERS_SKU_SID, :unique_key => ["sku"], :delimiter => COL_SEP
				puts "END"
				@err += 'New items imported - ' + @res.inserted.to_s +
				'; Existed items updated - ' + @res.updated.to_s
				unless r_s.empty? 
					@err += '</br> Unknown supplier in lines ' + r_s
				end
				unless r_p.empty? 
					@err += '</br> Wrong <price> format in lines ' + r_s
				end

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
