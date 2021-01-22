class PagesController < ApplicationController
  def home
    @designers = SoundDesigner.all
    @sfx_packs = SfxPack.all

    current_sales = Sale.where("end_date > ?", Date.current)
    @current_sales_list = {}
    current_sales.each do |sale|
      sale.packs.each do |pack_id|
        @current_sales_list[pack_id] = sale.percentage
      end
    end
  end

  def about
  end

  def eula
  end
end
