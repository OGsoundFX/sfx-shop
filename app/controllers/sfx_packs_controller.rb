class SfxPacksController < ApplicationController
  before_action :store_location
  def show
    @pack = SfxPack.find(params[:id])
    @designer = SoundDesigner.find(@pack.sound_designer_id)
    @designer_name = "#{@designer.first_name} #{@designer.last_name}"
    current_sales = Sale.where("end_date > ?", Date.current)
    current_sales.each do |sale|
      sale.packs.each do |pack_id|
        @discount = sale.percentage if @pack.id == pack_id
      end
    end
  end
end
