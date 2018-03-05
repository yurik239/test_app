class ImportsController < ApplicationController
	def new
		@import = Import.new
	end
	def create
		@import = Import.new(import_params)
	puts '111'
	puts @import.datafile.url
		if @import.save
			@import.import_file
			redirect_to imports_path
		else
			render :new
		end
	end
	def index
		@imports = Import.all.order(:created_at).page params[:page]
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
