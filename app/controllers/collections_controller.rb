class CollectionsController < ApplicationController
  before_action :authenticate_user!

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
    cart_create_update
    redirect_to request.referer
  end

  def update
    # this action is to remove tracks from collection
    raise
    # destroy collection if last track of a collection
    # destroy collection & cart if last track of collection and collection only item in cart
    cart = Cart.where(user_id: current_user.id).last
    collection = Collection.find(params[:id].to_i)
    collection.tracks.delete(params[:track].to_i)
    collection.total_points = points(collection.tracks)
    collection.price_cents = collection_categories(collection.total_points)
    collection.save
    if collection.tracks == []
      cart_remove_collection(collection, cart)
      collection.destroy
    end
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

  def create_zip_collection
    
    Aws.config.update({
      region: 'eu-central-1',
      access_key_id: ENV['ACCESS_KEY_ID'],
      secret_access_key: ENV['SECRET_ACCESS_KEY']
    })
    s3 = Aws::S3::Resource.new
    bucket = s3.bucket('single-track-list')
    files = []
    collection = Collection.find(params[:collection]).title
    tracks = Collection.find(params[:collection]).tracks
    tracks.each do |track|
      name = SingleTrack.find(track).link.split('.com').last[1..-1]
      files << name
    end
    time = Time.now.to_i
    folder = "#{current_user.username}_#{collection}_#{time}"
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

  private

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
end
