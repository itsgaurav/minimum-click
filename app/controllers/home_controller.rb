class HomeController < ApplicationController
  before_filter :valid_input, :only => :upload

  def index
  end

  # Reads the input file and prints solution
  def upload
    solve(@viewable_list,@browse_list)
    render :result
  end

  private
  # Checkk if input present and valid
  def valid_input
		if params[:input_data].present?
      check_format(params[:input_data])
    else
			raise_error "INCORRECT FILE CONTENT"
		end
  end

  # Helper method to check file format
  def check_format(file)
  	begin
      content = file_content(file)
      content = content.split("\n").reject { |c| c.empty? }
      read_file(content)
    rescue
      raise_error "ERROR READING FILE"
    end
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

  def read_file(lines)
    raise_error and return if lines.count!=3
    temp = lines[0].split(" ") # Read start and end channel
    raise_error and return if temp.count!=2
    channel_list = (temp[0].to_i..temp[1].to_i).to_a # channel arrays
    temp = lines[1].split(" ") # Blocked List
    blocked_list_count = temp[0].to_i
    blocked_list = temp[1..-1].map { |e| e.to_i }
    raise_error and return if blocked_list.count!=blocked_list_count
    @viewable_list = channel_list - blocked_list
    temp = lines[2].split(" ") # Blocked List
    browse_list_count = temp[0].to_i
    @browse_list = temp[1..-1].map { |e| e.to_i }
    raise_error and return if @browse_list.count!=browse_list_count
  end

  def solve(view_list,browse_list)
    ans=browse_list[0].to_s.size
    prev=browse_list[0]
    back=browse_list[0]
    len = view_list.count
    browse_list[1..-1].each do |ch|
      ways = [get_distance(view_list,ch,prev,len), ch.to_s.size, 1+get_distance(view_list,ch,back,len)]
      ans+=ways.min
      back=prev
      prev=ch
    end
    @result = ans
  end

  # List, 1st elem, 2nd elem, length of array
  def get_distance(view_list,a,b,n) 
    start = view_list.index(a)
    finish = view_list.index(b)
    dist = (start-finish).abs
    return [dist,n-dist].min
  end

end
