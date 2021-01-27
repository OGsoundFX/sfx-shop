class PaymentsController < ApplicationController
  def new
    @order = current_user.orders.where(status: 'pending').find(params[:order_id])
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
  end
end
