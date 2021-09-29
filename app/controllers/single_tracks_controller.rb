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
      "weather": '<i class="fas fa-cloud-showers-heavy"></i>',
      "random": '<i class="fas fa-volume"></i>'
    }
    if params[:search] == nil || params[:search] == ""
      @tracks = SingleTrack.all
    else
      @tracks = SingleTrack.search_single_tracks(params[:search])
      @search = params[:search]
    end
  end
end
