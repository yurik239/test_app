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
		if @item.save
			redirect_to items_path
		else
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
		
		
		if @item.update(item_params)
			item_supplier
			@item.save
			redirect_to items_path
		
		else
			redirect_to items_path, error: 'Ops..'
		end
	end
	
	def destroy
		find_item
		if @item.destroy
			redirect_to items_path
		else
			redirect_to items_path, error: 'Ops..'
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
