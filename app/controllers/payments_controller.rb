class PaymentsController < ApplicationController
  def new
    @order = current_user.orders.where(status: 'pending').find(params[:order_id])
    if @order.multiple == false
      @photo = @order.sfx_pack.photos[0]
    end
  end
end
