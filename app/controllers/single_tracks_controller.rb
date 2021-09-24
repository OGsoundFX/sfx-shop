class SingleTracksController < ApplicationController
  def index
    @track = SingleTrack.first
    @tracks = SingleTrack.all
  end
end
