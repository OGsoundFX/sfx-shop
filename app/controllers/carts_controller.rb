class CartsController < ApplicationController
  before_action :authenticate_user!
  def cart_order
    if Cart.where(user_id: current_user.id).count == 1
      @items = Cart.where(user_id: current_user.id).first
      @items.items << SfxPack.find(params[:pack_id]).id.to_i
      @items.save
    else
      # check which of the 2 lines bellow is correct
      # @items = Cart.create(user_id: current_user.id).first
      @items = Cart.create(user_id: current_user.id)
      @items.items = []
      @items.items << SfxPack.find(params[:pack_id]).id.to_i
      @items.save
    end
    redirect_to cart_path
  end

  def cart
    @items = Cart.where(user_id: current_user.id).first
  end

  def delete_item
    @cart = Cart.where(user_id: current_user.id).first
    @cart.items.delete(params[:pack_id].to_i)
    @cart.save
    redirect_to cart_path
  end

  def destroy_cart
    cart.destroy
    redirect_to dashboard_path
  end
end
