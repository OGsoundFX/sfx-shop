class CollectionsController < ApplicationController
  before_action :authenticate_user!

  def create
    # this action is not only to create a collection from scratch but add tracks to collection
    user_collection = Collection.where("user_id = #{current_user.id} and purchased = false").last
    if !user_collection.nil?
      user_collection.tracks << params[:track].to_i
      user_collection.tracks = user_collection.tracks.uniq
      user_collection.save
    else
      Collection.create(user_id: current_user.id, tracks: [params[:track].to_i])
    end
    redirect_to list_path
  end

  def update
    # this action is to remove tracks from collection or destroy collection when last track is removed
    collection = Collection.find(params[:id].to_i)
    collection.tracks.delete(params[:track].to_i)
    collection.save
    redirect_to list_path
  end
end
