class SingleTracksController < ApplicationController
  def index
    @icons = {
      "all": '<i class="fas fa-volume-up"></i>',
      "action": '<i class="fas fa-swords"></i>',
      "medieval": '<i class="fab fa-fort-awesome"></i>',
      "outdoor":	'<i class="fas fa-trees"></i>',
      "underground": '<i class="fas fa-dungeon"></i>',
      "scary":	'<i class="fas fa-ghost"></i>',
      "monsters":	'<i class="fas fa-dragon"></i>',
      "disasters": '<i class="fas fa-volcano"></i>',
      "weather": '<i class="fas fa-cloud-showers-heavy"></i>',
      "miscellaneous": '<i class="fas fa-volume-up"></i>',
      "footsteps": '<i class="fas fa-shoe-prints"></i>',
      "magic": '<i class="fas fa-cauldron"></i>',
      "scifi": '<i class="fas fa-rocket"></i>',
      "default": '<i class="fas fa-volume-up"></i>'
    }

    @categories = @icons.keys
    @collection = Collection.where("user_id = #{current_user.id} and purchased = false").last if current_user
    @newest = true if params[:order_by_dropdown] == "newest"

    # order by
    if params[:order_by_dropdown] != nil && params[:order_by_dropdown] != ""
      if params[:previous_category] != ""
        if params[:order_by_dropdown] == "newest"
          @tracks = SingleTrack.where(category: params[:previous_category]).reorder(created_at: :desc).page params[:page]
          @dropdown = params[:previous_category]
        else
          # implement if else statement based on asc or desc order
          if params["asc-desc"] == "desc"
            @tracks = SingleTrack.where(category: params[:previous_category]).reorder("#{params[:order_by_dropdown]} DESC").page params[:page]
          else
            @tracks = SingleTrack.where(category: params[:previous_category]).reorder(params[:order_by_dropdown]).page params[:page]
          end
          @dropdown = params[:previous_category]
        end
      elsif params[:previous_sort] == "Search by keyword" || params[:previous_sort] == ""
        if params[:order_by_dropdown] == "newest"
          @tracks = SingleTrack.reorder(created_at: :desc).page params[:page]
        else
          # implement if else statement based on asc or desc order
          if params["asc-desc"] == "desc"
            @tracks = SingleTrack.reorder("#{params[:order_by_dropdown]} DESC").page params[:page]
          else
            @tracks = SingleTrack.reorder(params[:order_by_dropdown]).page params[:page]
          end
        end
      else
        if params[:order_by_dropdown] == "newest"
          @tracks = SingleTrack.search_single_tracks(params[:previous_sort]).reorder(created_at: :desc).page params[:page]
          @search = params[:previous_sort]
        else
          # implement if else statement based on asc or desc order
          if params["asc-desc"] == "desc"
            @tracks = SingleTrack.search_single_tracks(params[:previous_sort]).reorder("#{params[:order_by_dropdown]} DESC").page params[:page]
          else
            @tracks = SingleTrack.search_single_tracks(params[:previous_sort]).reorder(params[:order_by_dropdown]).page params[:page]
          end
          @search = params[:previous_sort]
        end
      end
      @order = params[:order_by_dropdown]
    else
      @order = params[:order_by_dropdown]
      # search by category
      if params[:dropdown] == nil || params[:dropdown] == ""
        # search by keyword
        if params[:search] == nil || params[:search] == ""
          @tracks = SingleTrack.order("random()").page params[:page]
          @search = "Search by keyword"
        else
          if params[:order_by_dropdown] == "newest"
            @tracks = SingleTrack.search_single_tracks(params[:search]).reorder(created_at: :desc).page params[:page]
            @search = params[:search]
          else
            @tracks = SingleTrack.search_single_tracks(params[:search]).page params[:page]
            @search = params[:search]
          end
        end
      elsif params[:dropdown] == "all"
        if params[:order_by_dropdown] == "newest"
          @tracks = SingleTrack.all.order(created_at: :desc).page params[:page]
          @search = "Search by keyword"
        else
          @tracks = SingleTrack.page params[:page]
          @search = "Search by keyword"
        end
      else
        if params[:order_by_dropdown] == "newest"
          @tracks = SingleTrack.reorder(created_at: :desc).page params[:page]
          @search = "Search by keyword"
          @dropdown = params[:dropdown]
        else
          @tracks = SingleTrack.where(category: params[:dropdown]).page params[:page]
          @search = "Search by keyword"
          @dropdown = params[:dropdown]
        end
      end
    end

    # filters
    if params[:filters] != nil && params[:filters] != ""
      points_grid = SingleTrack.points_grid
      filters = {fantasy: nil, loop: nil, minsize: nil, maxsize: nil, minpoints: nil, maxpoints: nil}
      filters_array = params[:filters].split(",")
      filters_array.each do |filter|
        if filter.include?("sec")
          if filter == "5sec"
            filters[:minsize] = 0
            filters[:maxsize] = points_grid[:"5"]
          elsif filter == "30sec"
            filters[:minsize] = points_grid[:"5"]
            filters[:maxsize] = points_grid[:"30"]
          elsif filter == "60sec"
            filters[:minsize] = points_grid[:"30"]
            filters[:maxsize] = points_grid[:"60"]
          elsif filter == "120sec"
            filters[:minsize] = points_grid[:"60"]
            filters[:maxsize] = 1000000000
          end
        else
          filters[:minsize] = 0
          filters[:maxsize] = 1000000000
        end
        if filter.include?("points")
          if filter == "2points"
            filters[:minpoints] = 0
            filters[:maxpoints] = 2
          elsif filter == "3points"
            filters[:minpoints] = 2
            filters[:maxpoints] = 5
          elsif filter == "5points"
            filters[:minpoints] = 5
            filters[:maxpoints] = 1000000000
          end
        else
          filters[:minpoints] = 0
          filters[:maxpoints] = 1000000000
        end
      end
      fantasy = true if filters_array.include?("fantasy")
      fantasy = false if filters_array.include?("nonFantasy")
      loopable = true if filters_array.include?("loop")
      loopable = false if filters_array.include?("nonLoop")
      filters[:fantasy] = fantasy
      filters[:loop] = loopable
      if params[:search] && params[:search] != "Search by keyword"
        @tracks = SingleTrack.search_single_tracks(params[:search]).where("size < #{filters[:maxsize]} and size > #{filters[:minsize]} and points < #{filters[:maxpoints]} and points >= #{filters[:minpoints]} #{'and loop = true' if loopable == true} #{'and fantasy = true' if fantasy == true} #{'and fantasy = false' if fantasy == false}").page params[:page]
      elsif params[:category]
        @tracks = SingleTrack.where("category = '#{params[:category]}' and size < #{filters[:maxsize]} and size > #{filters[:minsize]} and points < #{filters[:maxpoints]} and points >= #{filters[:minpoints]} #{'and loop = true' if loopable == true} #{'and fantasy = true' if fantasy == true} #{'and fantasy = false' if fantasy == false}").page params[:page]
        @dropdown = params[:category]
      else
        @tracks = SingleTrack.where("size < #{filters[:maxsize]} and size > #{filters[:minsize]} and points < #{filters[:maxpoints]} and points >= #{filters[:minpoints]} #{'and loop = true' if loopable == true} #{'and fantasy = true' if fantasy == true} #{'and fantasy = false' if fantasy == false}").page params[:page]
      end
    else
    end
    @filters = params[:filters] || ""
    @order_type = params["asc-desc"]
  end

  def download_single
    require 'open-uri'
    url = params[:url]
    title = params[:title]
    data = URI.open(url).read
    send_data data, :disposition => 'attachment', :filename=>"#{title}.wav"
  end

  def create_zip
    
    Aws.config.update({
      region: 'eu-central-1',
      access_key_id: ENV['ACCESS_KEY_ID'],
      secret_access_key: ENV['SECRET_ACCESS_KEY']
    })
    s3 = Aws::S3::Resource.new
    bucket = s3.bucket('single-track-list')
    files = []
    tracks = params[:tracks]
    tracks.each do |track|
      name = SingleTrack.find(track).link.split('.com').last[1..-1]
      files << name
    end
    time = Time.now.to_i
    folder = "#{current_user.username}_#{time}"
    Dir.mkdir(Rails.root.join('app', 'assets', 'uploads', folder))
    files.each do |file_name|
      file_obj = bucket.object(file_name)
      file_obj.get(response_target: Rails.root.join('app', 'assets', 'uploads', folder, file_name.split('/').last))
      
    end
    require 'zip'
    require 'fileutils'
    Zip::File.open(Rails.root.join('app', 'assets', 'uploads', folder, "#{folder}.zip"), Zip::File::CREATE) do |zipfile|
      files.each do |file_name|
       # Add the file to the zip
        zipfile.add(file_name, File.join(Rails.root.join('app', 'assets', 'uploads', folder, file_name.split('/').last)))
      end
    end
    send_file Rails.root.join('app', 'assets', 'uploads', folder, "#{folder}.zip"), :disposition => 'attachment'
  end
end
