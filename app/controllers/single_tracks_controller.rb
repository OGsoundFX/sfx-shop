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
      @tracks = SingleTrack.all
      # search by keyword
      if params[:search] == nil || params[:search] == ""
        @tracks = SingleTrack.all
        @search = "Search by keyword"
      else
        @tracks = SingleTrack.search_single_tracks(params[:search])
        @search = params[:search]
      end
    elsif params[:dropdown] == "all"
      @tracks = SingleTrack.all
      @search = "Search by keyword"
    else
      @tracks = SingleTrack.where(category: params[:dropdown])
      @search = "Search by keyword"
    end

  end
end
