class SuppliersController < ApplicationController
	def new
	@supplier = Supplier.new
	end
	
	def create
	@supplier = Supplier.new(supplier_params)
		if Resque.queue_sizes["default"] == 0
			if @supplier.save
				flash[:success] = "Supplier created"
				redirect_to suppliers_path
			else
				flash[:danger] = "Ops ..."
				render :new
			end
		else
			flash[:danger] = "You can not create Supplier while qoing imports "
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
		if Resque.queue_sizes["default"] == 0
			if @supplier.update(supplier_params)
				flash[:success] = "Supplier updated"
				redirect_to suppliers_path
			else
				flash[:danger] = "Ops ..."
				redirect_to suppliers_path, error: 'Ops..'
			end
		else
			flash[:danger] = "You can not update Supplier while qoing imports "
			redirect_to suppliers_path
		end
	end
	
	def destroy
		find_supplier
		@c = @supplier.sup_code
		if Resque.queue_sizes["default"] == 0
			if @supplier.destroy
				Item.where(:sup_code => @c).update_all(sup_code: '', supplier_id: nil)
				flash[:success] = "Supplier delated"
				redirect_to suppliers_path
			else
				flash[:danger] = "Ops ..."
				redirect_to suppliers_path, error: 'Ops..'
			end
		else
			flash[:danger] = "You can not delete Supplier while qoing imports "
			redirect_to suppliers_path
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
