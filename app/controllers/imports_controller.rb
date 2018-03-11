class ImportsController < ApplicationController
	def new
		@import = Import.new
	end
	def create
		@import = Import.new(import_params)

		if @import.save
			puts @import.id
			ImportJob.perform_later @import.id
			flash[:success] = "File #{@import.filename} will be imported on backend "
			redirect_to imports_path
		else
			flash[:danger] = "Ops ..."
			render :new
		end
	end
	def index
		@imports = Import.all.order(id: :desc).page params[:page]
	end
	def destroy
		find_import
		if @import.destroy
			redirect_to imports_path
		else
			redirect_to imports_path, error: 'Ops..'
		end
	end
	
	private
	def import_params
		params[:import].permit(:datafile, :body, :error)
	end

	def find_import
		@import = Import.find(params[:id])
	end
end
