class SingleTracksController < ApplicationController
  def index
    @icons = {
      "action": '<i class="fas fa-swords"></i>',
      "medieval": '<i class="fab fa-fort-awesome"></i>',
      "outdoor":	'<i class="fas fa-trees"></i>',
      "underground": '<i class="fas fa-dungeon"></i>',
      "scary":	'<i class="fas fa-ghost"></i>',
      "monsters":	'<i class="fas fa-dragon"></i>',
      "disasters": '<i class="fas fa-volcano"></i>',
      "weather": '<i class="fas fa-cloud-showers-heavy"></i>'
    }

    @categories = @icons.keys

    # search by category
    if params[:dropdown] == nil || params[:dropdown] == ""
      @tracks = SingleTrack.page params[:page]
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
    end
  end

  def download_single
    require 'open-uri'
    url = params[:url]
    title = params[:title]
    data = open(url).read
    send_data data, :disposition => 'attachment', :filename=>"#{title}.mp3"
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
      name = SingleTrack.find(track).link.split('/').last
      files << name
    end
    time = Time.now.to_i
    folder = "#{current_user.username}_#{time}"
    Dir.mkdir(Rails.root.join('app', 'assets', 'uploads', folder))
    files.each do |file_name|
      file_obj = bucket.object(file_name)
      file_obj.get(response_target: Rails.root.join('app', 'assets', 'uploads', folder, file_name))

    end
    require 'zip'
    require 'fileutils'
    Zip::File.open(Rails.root.join('app', 'assets', 'uploads', folder, "#{folder}.zip"), Zip::File::CREATE) do |zipfile|
      files.each do |file_name|
       # Add the file to the zip
        zipfile.add(file_name, File.join(Rails.root.join('app', 'assets', 'uploads', folder, file_name)))
      end
    end
    send_file Rails.root.join('app', 'assets', 'uploads', folder, "#{folder}.zip"), :disposition => 'attachment'
    # require 'timeout'
    # status = Timeout::timeout(5) {
    #   FileUtils.rm_r Rails.root.join('app', 'assets', 'uploads', folder)
    # }

  end
end
