class ZipCollectionJob < ApplicationJob
  queue_as :default

  require 'zip'
  require 'open-uri'
  require 'aws-sdk-s3'

  def perform(*args)
    params = args[0]
    current_user = User.find(args[1])
    Aws.config.update({
      region: 'eu-central-1',
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    })
    time = Time.now.to_i
    order = Order.find(params[:order])

    if params[:type] == "single_tracks"
      collection_download = false
      tracks = params[:tracks]
      zip_filename = "#{current_user.username}_tracks_#{time}.zip"
    else
      collection_download = true
      collection = Collection.find(params[:collection])
      tracks = collection.tracks
      zip_filename = "#{current_user.username}_#{collection.title}_#{time}.zip"
    end

    # Create a temp file on disk
    tempfile = Tempfile.new([zip_filename, '.zip'], binmode: true)
    Zip::OutputStream.open(tempfile) do |zos|
      tracks.each do |track_id|
        track = SingleTrack.find(track_id)
        s3_key = track.link.split('.com').last[1..-1]
        filename = File.basename(s3_key)
        # Stream from S3
        s3_url = "https://single-track-list.s3.eu-central-1.amazonaws.com/#{s3_key}"
        URI.open(s3_url) do |file_stream|
          zos.put_next_entry(filename)
          IO.copy_stream(file_stream, zos)
        end
      end
    end

    tempfile.rewind

    # Upload to S3 using aws-sdk-s3
    s3 = Aws::S3::Resource.new(region: 'eu-central-1')
    obj = s3.bucket('bamsfx-temp-zip-files').object("zips/#{zip_filename}")
    obj.upload_file(tempfile.path, acl: 'private')

    # Generate a presigned URL (expires in 1 day)
    url = obj.presigned_url(:get, expires_in: 86400)
    # Clean up temp file
    tempfile.close
    tempfile.unlink

    # create a download_link and redirect
    if collection_download
      DownloadLink.create(url: url, collection: collection, collection_download: true, order: order, validity_duration: Time.at(1.day))
    else
      DownloadLink.create(url: url, collection_download: false, order: order, validity_duration: Time.at(1.day))
    end
    # Return the URL to the user (e.g., as JSON)
    # render json: { download_url: url }
  end
end
