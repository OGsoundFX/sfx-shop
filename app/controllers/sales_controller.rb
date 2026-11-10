class SalesController < ApplicationController
  before_action :check_admin

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
    unless @sale.save
      redirect_to new_sale_path, alert: @sale.errors.full_messages.to_sentence
      return
    end

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

  def check_admin
    redirect_to root_path, alert: "You are not authorised to visit this page" unless current_user&.admin?
  end
end
