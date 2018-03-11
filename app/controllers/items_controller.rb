class ItemsController < ApplicationController
	def new
		@suppliers = Array.new 
		Supplier.all.order(:sup_code).each do |code|
		@suppliers << code.sup_code
		end
		@item = Item.new
	end
	
	def create
		@item = Item.new(item_params)
		item_supplier
		if Resque.queue_sizes["default"] == 0
			if @item.save
				flash[:success] = "Item created"
				redirect_to items_path
			else
				flash[:danger] = "Ops ..."
				render :new
			end
		else
			flash[:danger] = "Yuo can not create Item while qoing imports "
			render :new
		end
	end
	
	def show
		find_item
	end
	
	def index
		@items = Item.all.order(:sku).page params[:page]
	end
	
	def edit
		@suppliers = Array.new 
		Supplier.all.order(:sup_code).each do |code|
		@suppliers << code.sup_code
		end
		find_item
	end
	
	def update
		find_item
		
		if Resque.queue_sizes["default"] == 0
			if @item.update(item_params)
				item_supplier
				@item.save
				flash[:success] = "Item updated"
				redirect_to items_path
			
			else
				flash[:danger] = "Ops ..."
				redirect_to items_path, error: 'Ops..'
			end
		else
			flash[:danger] = "You can not update Item while qoing imports "
			redirect_to items_path
		end
	end
	
	def destroy
		find_item
		if Resque.queue_sizes["default"] == 0
			if @item.destroy
				flash[:success] = "Item delated"
				redirect_to items_path
			else
				flash[:danger] = "Ops ..."
				redirect_to items_path, error: 'Ops..'
			end
		else
			flash[:danger] = "You can not delete Item while qoing imports "
			redirect_to items_path
		end
	end
	
	private
	
	def item_params
		params[:item].permit(:sup_code, :sku, :supplier_id, :price, :add1, :add2, :add3, :add4, :add5, :add6)
	end
	
	def item_supplier
		if @item.sup_code.empty?
		@item.supplier_id = nil
		else
		@item.supplier_id = Supplier.find_by(sup_code: @item.sup_code).id
		end
	end
	
	def find_item
		@item = Item.find(params[:id])
	end
end
