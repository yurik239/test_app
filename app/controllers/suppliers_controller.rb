class SuppliersController < ApplicationController
	def new
	@supplier = Supplier.new
	end
	
	def create
	@supplier = Supplier.new(supplier_params)
		if @supplier.save
			redirect_to suppliers_path
		else
			render :new
		end
	end
	
	def index
		@suppliers = Supplier.all.order(:sup_code).page params[:page]
	end
	
	def edit
		find_supplier
	end
	
	def update
		find_supplier
		if @supplier.update(supplier_params)
			redirect_to suppliers_path
		else
			redirect_to suppliers_path, error: 'Ops..'
		end
	end
	
	def destroy
		find_supplier
		@c = @supplier.sup_code
		if @supplier.destroy
			Item.where(:sup_code => @c).update_all(sup_code: '', supplier_id: nil)
			redirect_to suppliers_path
		else
			redirect_to suppliers_path, error: 'Ops..'
		end
	end
	
	private
	
	def supplier_params
		params[:supplier].permit(:sup_code, :sup_name)
	end
	
	def find_supplier
		@supplier = Supplier.find(params[:id])
	end
		
end
