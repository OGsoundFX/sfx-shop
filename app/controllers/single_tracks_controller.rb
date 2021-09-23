class SingleTracksController < ApplicationController
  def index
    @track = SingleTrack.first
  end
end
