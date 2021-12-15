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
      "default": '<i class="fas fa-volume-up"></i>'
    }

    @categories = @icons.keys

    # order by
    if params[:order_by_dropdown] != nil && params[:order_by_dropdown] != ""
      if params[:previous_category] != ""
        @tracks = SingleTrack.where(category: params[:previous_category]).reorder(params[:order_by_dropdown]).page params[:page]
        @dropdown = params[:previous_category]
      elsif params[:previous_sort] == "Search by keyword" || params[:previous_sort] == ""
        @tracks = SingleTrack.reorder(params[:order_by_dropdown]).page params[:page]
      else
        @tracks = SingleTrack.search_single_tracks(params[:previous_sort]).reorder(params[:order_by_dropdown]).page params[:page]
        @search = params[:previous_sort]
      end
      @order = params[:order_by_dropdown]
    else
      @order = params[:order_by_dropdown]
      # search by category
      if params[:dropdown] == nil || params[:dropdown] == ""
        # search by keyword
        if params[:search] == nil || params[:search] == ""
          @tracks = SingleTrack.page params[:page]
          @search = "Search by keyword"
        else
          @tracks = SingleTrack.search_single_tracks(params[:search]).page params[:page]
          @search = params[:search]
        end
      elsif params[:dropdown] == "all"
        @tracks = SingleTrack.page params[:page]
        @search = "Search by keyword"
      else
        @tracks = SingleTrack.where(category: params[:dropdown]).page params[:page]
        @search = "Search by keyword"
        @dropdown = params[:dropdown]
      end

    end
  end

  def download_single
    require 'open-uri'
    url = params[:url]
    title = params[:title]
    data = open(url).read
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
    redirect_to root_path
    # require 'zip'
    # require 'fileutils'
    # Zip::File.open(Rails.root.join('app', 'assets', 'uploads', folder, "#{folder}.zip"), Zip::File::CREATE) do |zipfile|
    #   files.each do |file_name|
    #    # Add the file to the zip
    #     zipfile.add(file_name, File.join(Rails.root.join('app', 'assets', 'uploads', folder, file_name.split('/').last)))
    #   end
    # end
    # send_file Rails.root.join('app', 'assets', 'uploads', folder, "#{folder}.zip"), :disposition => 'attachment'
  end
end
