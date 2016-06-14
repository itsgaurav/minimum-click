class HomeController < ApplicationController
  before_filter :valid_input, :only => :upload

  def index
  end

  def upload
  	byebug
  	uploaded_io = params[:input_data]
  	File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
    	file.write(uploaded_io.read)
    end
  end

  private
  def valid_input
		if params[:input_data].blank? || check_format(params[:input_data])
			raise_error "INCORRECT FILE CONTENT"
		end
  end

  def check_format(file)
  	content = file_content(file)
  end

  def file_content(file)
  	if file.respond_to?(:read)
  		content = file.read
		elsif file.respond_to?(:path)
  		content = File.read(file_data.path)
  	else
  		raise_error 
  	end
  	content
  end

  def raise_error(error)
  	flash.now[:notice] = error
		render :index and return
  end


end
