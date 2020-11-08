class SfxPacksController < ApplicationController
  before_action :store_location
  def show
    @pack = SfxPack.find(params[:id])
    @designer = SoundDesigner.find(@pack.sound_designer_id)
    @designer_name = "#{@designer.first_name} #{@designer.last_name}"
  end
end
