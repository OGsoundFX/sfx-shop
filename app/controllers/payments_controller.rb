class PaymentsController < ApplicationController
  def new
    @order = current_user.orders.where(status: 'pending').find(params[:order_id])
    @collection = Collection.find(@order.collections.first) if !@order.collections.nil? && @order.collections != []
    if @order.multiple == false
      @photo = @order.sfx_pack.photos[0]
      items = []
      items << @order.sfx_pack_id
    else
      items = @order.packs
    end
    
    current_sales = Sale.where("end_date > ?", Date.current)
    @current_sales_list = {}
    items.each do |item|
      current_sales.each do |sale|
        @current_sales_list[item] = sale.percentage if sale.packs.include? item
      end
    end
    # Calculating sub-total prices for packs & tracks
    @total_tracks_price = 0
    @order.tracks.each { |track| @total_tracks_price += (SingleTrack.find(track).price_cents / 100.to_f) }
    # @total-pack-price depending on whether there is a sale and whether there are multiple packs and IF there are packs
  end
end
