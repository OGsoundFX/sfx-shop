class CollectionsController < ApplicationController
  before_action :authenticate_user!, except: [:templates_index, :templates_show]

  # ! Pack builder section 👇
  def pack_builder
    @collection = Collection.where("user_id = #{current_user.id} and purchased = false").last if current_user
    @search = params[:search].presence if params[:search].is_a?(String)
    @dropdown = params[:dropdown].presence if params[:dropdown].is_a?(String)
    @includes_ai = params[:includes_ai] if %w[true false].include?(params[:includes_ai])
    @asset_type = params[:asset_type] if SingleTrack.asset_types.key?(params[:asset_type])

    @icons = {
      "all": '<i class="fas fa-volume-up"></i>',
      "action": '<i class="fas fa-bomb"></i>',
      "medieval": '<i class="fab fa-fort-awesome"></i>',
      "outdoor":	'<i class="fas fa-tree"></i>',
      "underground": '<i class="fas fa-dungeon"></i>',
      "scary":	'<i class="fas fa-ghost"></i>',
      "monsters":	'<i class="fas fa-dragon"></i>',
      "disasters": '<i class="fas fa-mountain"></i>',
      "weather": '<i class="fas fa-cloud-showers-heavy"></i>',
      "miscellaneous": '<i class="fas fa-volume-up"></i>',
      "footsteps": '<i class="fas fa-shoe-prints"></i>',
      "magic": '<i class="fas fa-hat-wizard"></i>',
      "scifi": '<i class="fas fa-rocket"></i>',
      "default": '<i class="fas fa-volume-up"></i>'
    }

    @categories = SfxPack.categories
    @categories.unshift('All')

    tracks = SingleTrack.all
    tracks = tracks.where(category: @dropdown.downcase) if @dropdown.present? && @dropdown.downcase != "all"
    tracks = tracks.search_single_tracks(@search) if @search.present?
    tracks = tracks.where(includes_ai: @includes_ai == "true") if @includes_ai.present?
    tracks = tracks.where(asset_type: @asset_type) if @asset_type.present?

    @total_sounds = tracks.count
    @sfx_tracks = tracks.page(params[:page]).per(20)
  end

  def create_builder_pack
    track = SingleTrack.find params[:track]
    collection = current_user.collections.where(purchased: false).last ||
      current_user.collections.new(tracks: [], total_points: 0, price_cents: 0)
    add_track_to_builder_collection(collection, track)
  end

  def add_builder_track
    track = SingleTrack.find params[:track]
    collection = current_user.collections.where(purchased: false).find(params[:collection])
    add_track_to_builder_collection(collection, track)
  end

  def remove_builder_track
  end

  def remove_builder_collection
    Collection.find(params[:collection_id]).destroy
    cart = current_user.cart
    if cart.items == [] && cart.sinlge_tracks == []
      cart.destroy
    else
      cart.collections = []
      cart.save
    end
    redirect_to pack_builder_path
  end

  # ! Pack builder section 👆

  def create
    # this action is not only to create a collection from scratch but add tracks to collection
    user_collection = Collection.where("user_id = #{current_user.id} and purchased = false").last
    if !user_collection.nil?
      user_collection.tracks << params[:track].to_i
      user_collection.tracks = user_collection.tracks.uniq
      user_collection.total_points = points(user_collection.tracks)
      user_collection.price_cents = collection_categories(user_collection.total_points)
      user_collection.save
    else
      Collection.create(user_id: current_user.id, tracks: [params[:track].to_i], total_points: SingleTrack.find(params[:track].to_i).points, price_cents: 500)
    end
    if !current_user.cart.nil?
      cart = current_user.cart
      cart.sinlge_tracks.delete(params[:track].to_i)
      cart.save
    end
    cart_create_update
    redirect_to request.referer
  end

  def update
    # this action is to remove tracks from collection
    collection = Collection.find(params[:id].to_i)
    cart = Cart.where(user_id: current_user.id).last
    collection.tracks.delete(params[:track].to_i)
    collection.total_points = points(collection.tracks)
    collection.price_cents = collection_categories(collection.total_points)
    collection.save

    # re-adjust price if applies


    # destroy collection if doesn't contain tracks
    if collection.tracks == []
      cart_remove_collection(collection, cart)
      collection.destroy
    end

    # destroy cart if empty
    cart.destroy if cart.items == [] && cart.sinlge_tracks == [] && cart.collections == []
    redirect_to request.referer
  end

  def convert
    # this action is not only to create a collection from scratch but add tracks to collection
    user_collection = Collection.where("user_id = #{current_user.id} and purchased = false").last
    if !user_collection.nil?
      params[:tracks].each do |track|
        user_collection.tracks << track.to_i
        user_collection.tracks = user_collection.tracks.uniq
        user_collection.total_points = points(user_collection.tracks)
        user_collection.price_cents = collection_categories(user_collection.total_points)
      end
      user_collection.save
    else
      # track_points = params[:tracks].map { |track| track = SingleTrack.find(track).price}
      # sum_points = track_points.sum
      price = CollectionCategory.where("points > #{params[:points]}").first.price * 100
      Collection.create(user_id: current_user.id, tracks: params[:tracks], total_points: params[:points], price_cents: price)
    end
    # Deleting all the single tracks from user
    current_user.cart.sinlge_tracks = []
    current_user.cart.save!
    redirect_to request.referer
  end

  def remove_collection_from_cart
    # this action does 4 things:
    # 1- removes a track from collection
    # 2- removes collection from cart of collection is empty
    # 3- destroys collection if collection is empty
    # 4- destroys cart when collection is destroyed if no other items in cart
    collection = Collection.find(params[:collection])
    collection.tracks.delete(params[:track].to_i)
    if collection.tracks == []
      cart = Cart.where(user_id: current_user.id).first
      cart.collections = []
      if cart.items == [] && cart.collections = [] && cart.sinlge_tracks == []
        cart.destroy
      else
        cart.save
      end
      collection.destroy
    else
      collection.total_points = points(collection.tracks)
      collection.price_cents = collection_categories(collection.total_points)
      collection.save
    end
    redirect_to cart_path
  end

  def destroy_collection
    collection = Collection.find(params[:collection])
    cart = Cart.where(user_id: current_user.id).first
    if cart.items == [] && cart.sinlge_tracks == []
      cart.destroy
      collection.destroy
    else
      cart.collections = []
      cart.save
      collection.destroy
    end
    redirect_to cart_path
  end

  def name_update
    name = name_params["input-name"]
    collection = Collection.find(params[:collection])
    collection.title = name
    collection.save
  end

  # /note/👇 old way for zipping files, using asset folder for local storage
  # def create_zip_collection
  #   Aws.config.update({
  #     region: 'eu-central-1',
  #     access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  #     secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
  #   })
  #   s3 = Aws::S3::Resource.new
  #   bucket = s3.bucket('single-track-list')
  #   files = []
  #   collection = Collection.find(params[:collection]).title
  #   tracks = Collection.find(params[:collection]).tracks
  #   tracks.each do |track|
  #     name = SingleTrack.find(track).link.split('.com').last[1..-1]
  #     files << name
  #   end
  #   time = Time.now.to_i
  #   folder = "#{current_user.username}_#{collection}_#{time}"
  #   Dir.mkdir(Rails.root.join('app', 'assets', 'uploads', folder))
  #   files.each do |file_name|
  #     file_obj = bucket.object(file_name)
  #     file_obj.get(response_target: Rails.root.join('app', 'assets', 'uploads', folder, file_name.split('/').last))
  #   end
  #   require 'zip'
  #   require 'fileutils'
  #   Zip::File.open(Rails.root.join('app', 'assets', 'uploads', folder, "#{folder}.zip"), Zip::File::CREATE) do |zipfile|
  #     files.each do |file_name|
  #      # Add the file to the zip
  #       zipfile.add(file_name, File.join(Rails.root.join('app', 'assets', 'uploads', folder, file_name.split('/').last)))
  #     end
  #   end
  #   send_file Rails.root.join('app', 'assets', 'uploads', folder, "#{folder}.zip"), disposition: 'attachment'
  #   # redirect_to dashboard_path, notice: "Your pack was successfully downloaded"
  # end

  # /note/👇 new way for zipping files, using AWS S3 to stream. Problem files larger then 500mb crash on Heroku
  # require 'zip'
  # require 'stringio'
  # require 'open-uri'

  # def create_zip_collection
  #   collection = Collection.find(params[:collection])
  #   tracks = collection.tracks
  #   time = Time.now.to_i
  #   zip_filename = "#{current_user.username}_#{collection.title}_#{time}.zip"

  #   # Set up in-memory zip
  #   compressed_filestream = Zip::OutputStream.write_buffer do |zos|
  #     tracks.each do |track_id|
  #       track = SingleTrack.find(track_id)
  #       s3_key = track.link.split('.com').last[1..-1]
  #       filename = File.basename(s3_key)

  #       # Get the file stream from S3 (public or presigned)
  #       s3_url = "https://single-track-list.s3.eu-central-1.amazonaws.com/#{s3_key}"
  #       file_stream = URI.open(s3_url)

  #       # Add it to the zip stream
  #       zos.put_next_entry(filename)
  #       IO.copy_stream(file_stream, zos)
  #     end
  #   end

  #   compressed_filestream.rewind

  #   send_data compressed_filestream.read,
  #             filename: zip_filename,
  #             type: 'application/zip'
  # end

  # /note/👇 this approach creates the zipfile and stores it on AWS
  def create_zip_collection
    if params[:type] == "single_tracks"
      params_object = {order: params[:order], tracks: params[:tracks], type: params[:type]}
    else
      params_object = {order: params[:order], collection: params[:collection]}
    end
    ZipCollectionJob.perform_later(params_object, current_user.id)
    # ZipCollectionJob.perform_now(params_object, current_user.id)
    # Aws.config.update({
    #   region: 'eu-central-1',
    #   access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    #   secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    # })
    # time = Time.now.to_i
    # order = Order.find(params[:order])

    # if params[:type] == "single_tracks"
    #   collection_download = false
    #   tracks = params[:tracks]
    #   zip_filename = "#{current_user.username}_tracks_#{time}.zip"
    # else
    #   collection_download = true
    #   collection = Collection.find(params[:collection])
    #   tracks = collection.tracks
    #   zip_filename = "#{current_user.username}_#{collection.title}_#{time}.zip"
    # end

    # # Create a temp file on disk
    # tempfile = Tempfile.new([zip_filename, '.zip'], binmode: true)

    # Zip::OutputStream.open(tempfile) do |zos|
    #   tracks.each do |track_id|
    #     track = SingleTrack.find(track_id)
    #     s3_key = track.link.split('.com').last[1..-1]
    #     filename = File.basename(s3_key)

    #     # Stream from S3
    #     s3_url = "https://single-track-list.s3.eu-central-1.amazonaws.com/#{s3_key}"
    #     URI.open(s3_url) do |file_stream|
    #       zos.put_next_entry(filename)
    #       IO.copy_stream(file_stream, zos)
    #     end
    #   end
    # end

    # tempfile.rewind

    # # Upload to S3 using aws-sdk-s3
    # s3 = Aws::S3::Resource.new(region: 'eu-central-1')
    # obj = s3.bucket('bamsfx-temp-zip-files').object("zips/#{zip_filename}")
    # obj.upload_file(tempfile.path, acl: 'private')

    # # Generate a presigned URL (expires in 1 day)
    # url = obj.presigned_url(:get, expires_in: 86400)

    # # Clean up temp file
    # tempfile.close
    # tempfile.unlink

    # # create a download_link and redirect
    # if collection_download
    #   DownloadLink.create(url: url, collection: collection, collection_download: true, order: order, validity_duration: Time.at(1.hour))
    # else
    #   DownloadLink.create(url: url, collection_download: false, order: order, validity_duration: Time.at(1.hour))
    # end
    # # Return the URL to the user (e.g., as JSON)
    # # render json: { download_url: url }
    redirect_to dashboard_path
  end

  def create_template
    collection = Collection.find(params[:template][:collection])
    title = params[:template][:title]
    categories = params[:template][:categories].split(", " || "")
    template = TemplateCollection.new(title: title, total_points: collection.total_points, price: collection.price, tracks: collection.tracks, categories: categories)
    # template.photo = params[:template][:photo]
    if template.save
      redirect_to cart_path
    else
      redirect_to cart_path, alert: "Invalid entry"
    end
  end

  def templates_index
    @templates = TemplateCollection.where(active: true)
    @icons = {
      "all": '<i class="fas fa-volume-up"></i>',
      "action": '<i class="fas fa-bomb"></i>',
      "medieval": '<i class="fab fa-fort-awesome"></i>',
      "outdoor":	'<i class="fas fa-tree"></i>',
      "underground": '<i class="fas fa-dungeon"></i>',
      "scary":	'<i class="fas fa-ghost"></i>',
      "monsters":	'<i class="fas fa-dragon"></i>',
      "disasters": '<i class="fas fa-mountain"></i>',
      "weather": '<i class="fas fa-cloud-showers-heavy"></i>',
      "miscellaneous": '<i class="fas fa-volume-up"></i>',
      "footsteps": '<i class="fas fa-shoe-prints"></i>',
      "magic": '<i class="fas fa-hat-wizard"></i>',
      "scifi": '<i class="fas fa-rocket"></i>',
      "default": '<i class="fas fa-volume-up"></i>'
    }
  end

  def templates_show
    @icons = {
      "all": '<i class="fas fa-volume-up"></i>',
      "action": '<i class="fas fa-bomb"></i>',
      "medieval": '<i class="fab fa-fort-awesome"></i>',
      "outdoor":	'<i class="fas fa-tree"></i>',
      "underground": '<i class="fas fa-dungeon"></i>',
      "scary":	'<i class="fas fa-ghost"></i>',
      "monsters":	'<i class="fas fa-dragon"></i>',
      "disasters": '<i class="fas fa-mountain"></i>',
      "weather": '<i class="fas fa-cloud-showers-heavy"></i>',
      "miscellaneous": '<i class="fas fa-volume-up"></i>',
      "footsteps": '<i class="fas fa-shoe-prints"></i>',
      "magic": '<i class="fas fa-hat-wizard"></i>',
      "scifi": '<i class="fas fa-rocket"></i>',
      "default": '<i class="fas fa-volume-up"></i>'
    }
    @template_collection = TemplateCollection.find(params[:id])
    @collection = Collection.where("user_id = #{current_user.id} and purchased = false").last if current_user
    # @tracks = SingleTrack.all.reorder(created_at: :desc).page params[:page]
    @tracks = SingleTrack.where(id: @template_collection.tracks).reorder(created_at: :desc).page params[:page]
  end

  def add_template_to_cart
    convert_template_to_collection(params[:template_id])
    redirect_to cart_path
  end

  private

  def add_track_to_builder_collection(collection, track)
    collection_track_ids = (collection.tracks || []).map(&:to_i)
    collection_track_ids << track.id unless collection_track_ids.include?(track.id)
    collection.tracks = collection_track_ids
    collection.total_points = points(collection_track_ids)
    collection.price_cents = collection_categories(collection.total_points)

    unless collection.save
      redirect_to pack_builder_path, alert: "Unable to add this sound to your collection."
      return
    end

    cart_create_update

    if "$" != session[:currency]
      conversion_rate = CurrencyRate.where("base = ? AND target = ?", "USD", "EUR").order(created_at: :desc).first.rate.to_f
    else
      conversion_rate = 1
    end
    collection_tracks = SingleTrack.where(id: collection_track_ids).index_by(&:id)
    individual_value = collection_tracks.values.sum(&:price_cents) / 100.0
    collection_savings = individual_value - collection.price.to_f

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("pack-builder-add-button-#{track.id}", partial: "add_button_pack_builder", locals: {track: track, collection: collection}),
          turbo_stream.replace("right-pannel-top-track-count", partial: "collections/right_pannel_elements/top_track_count", locals: {collection: collection}),
          turbo_stream.replace("selected-track-list",
            partial: "collections/right_pannel_elements/selected_track_list",
            locals: {
              collection: collection,
              collection_track_ids: collection_track_ids,
              collection_tracks: collection_tracks,
              conversion_rate: conversion_rate
            }
          ),
          turbo_stream.replace("total_price_recap",
            partial: "collections/right_pannel_elements/total_price_recap",
            locals: {
              collection: collection,
              conversion_rate: conversion_rate,
              collection_savings: collection_savings,
              individual_value: individual_value
            }
          )
        ]
      end
      format.html { redirect_to pack_builder_path }
    end
  end

  def points(tracks)
    if tracks == []
      points = 0
    else
      points = tracks.map do |id|
        SingleTrack.find(id).points
      end
      points.reduce {|sum, el| sum += el}
    end
  end

  def collection_categories(points)
    case
    when points == 0
      0
    when points <= 20
      500
    when points <= 50
      1000
    when points <= 120
      2000
    when points <= 300
      4000
    else
      5000 # unlimited
    end
  end

  def cart_create_update
    if Cart.where(user_id: current_user.id).last.nil?
      # user_collections = current_user.collections.map {|coll| coll.id}
      Cart.create(collections: current_user_collections, user_id: current_user.id)
    else
      cart = Cart.where(user_id: current_user.id).last
      cart.collections = current_user_collections
      cart.save
    end
  end

  def current_user_collections
    current_user.collections.map {|coll| coll.id if coll.purchased == false}.compact
  end

  def cart_remove_collection(collection, cart)
    cart.collections.delete(collection.id)
    cart.save
  end

  def name_params
    params.permit("input-name")
  end

  def convert_template_to_collection(id)
    if Cart.where(user_id: current_user.id).last.nil?
      Cart.create(user_id: current_user.id)
    end
    template = TemplateCollection.find(id)
    if current_user.collections.where(purchased: false).count > 0
      collection = Collection.where(user: current_user, purchased: false).first
      collection.tracks += template.tracks
      collection.tracks = collection.tracks.uniq
      collection.title = template.title
      collection.template_collection_id = template.id
      # points = collection.total_points + template.total_points
      points = points(collection.tracks)
      collection.total_points = points
      collection.price_cents = collection_categories(points)
    else
      collection = Collection.new(title: template.title, total_points: template.total_points, tracks: template.tracks, template_collection_id: template.id, price_cents: template.price_cents, user: current_user)
    end
    collection.save
  end
end
