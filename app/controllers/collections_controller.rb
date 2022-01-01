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
    redirect_to list_path
  end

  def update
    # this action is to remove tracks from collection
    collection = Collection.find(params[:id].to_i)
    collection.tracks.delete(params[:track].to_i)
    collection.total_points = points(collection.tracks)
    collection.price_cents = collection_categories(collection.total_points)
    collection.save
    redirect_to list_path
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
    when points > 20 
      1000
    when points > 50
      2000
    when points > 100
      4000
    when points > 300
      # create a new pack / raise error
    else
      500
    end
  end
end
