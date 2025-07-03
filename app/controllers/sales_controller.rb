class SalesController < ApplicationController
  def new
    @sale = Sale.new

    @packs = ["All"]
    SfxPack.all.each do |pack|
      @packs << pack.title
    end
  end

  def create
    @sale = Sale.new(sale_params)

    if pack_params.include? "All"
      pack_array = []
      SfxPack.all.each do |pack|
        pack_array << pack.id unless pack.price_cents == 0
      end
    else
      pack_array = []
      pack_params.each do |pack|
        pack_array << SfxPack.where(title: pack).first.id if pack != ""
      end
    end

    @sale.packs = pack_array
    @sale.save
    redirect_to list_sales_path
  end

  def destroy
    Sale.find(params[:id]).destroy
    redirect_to list_sales_path
  end

  private

  def sale_params
    params.require(:sale).permit(:title, :percentage, :start_date, :end_date, :packs)
  end

  def pack_params
    params.require(:sale).permit(:title, :percentage, :start_date, :end_date, :packs)
    params[:sale][:packs]
  end
end
